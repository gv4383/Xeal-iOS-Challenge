//
//  NFCManager.swift
//  XealChallenge
//
//  Created by Goyo Vargas on 9/1/22.
//

import Foundation
import CoreNFC

typealias NFCReadingCompletion = (Result<NFCNDEFMessage?, Error>) -> Void
typealias AccountReadingCompletion = (Result<Account, Error>) -> Void

final class NFCManager: NSObject, ObservableObject {
    enum NFCError: LocalizedError {
        case readerUnavailable
        case invalidated(message: String)
        case invalidPayloadSize
        
        var errorDescription: String? {
            switch self {
            case .readerUnavailable:
                return NFCAlertMessages.readerNotAvailable
            case .invalidated(let message):
                return message
            case .invalidPayloadSize:
                return NFCAlertMessages.payloadSizeTooBig
            }
        }
    }
    
    enum NFCAction {
        case readAccount
        case updateAccount(account: Account)
        
        var alertMessage: String {
            switch self {
            case .readAccount:
                return NFCAlertMessages.readAccountDetails
            case .updateAccount(let account):
                return "\(NFCAlertMessages.updateAccount) \(account.name)"
            }
        }
    }
    
    private static let shared = NFCManager()
    private var action: NFCAction = .readAccount
    private var session: NFCNDEFReaderSession?
    private var completion: AccountReadingCompletion?
    
    static func performAction(_ action: NFCAction, completion: AccountReadingCompletion? = nil) {
        shared.action = action
        shared.completion = completion
        shared.session = NFCNDEFReaderSession(delegate: shared.self, queue: nil, invalidateAfterFirstRead: true)
        shared.session?.alertMessage = action.alertMessage
        shared.session?.begin()
    }
    
    // Entry point for all NFC actions
    private func read(
        tag: NFCNDEFTag,
        alertMessage: String = NFCAlertMessages.tagWasRead,
        readCompletion: NFCReadingCompletion? = nil
    ) {
        tag.readNDEF { message, error in
            if let error = error {
                self.handleError(error)
                return
            }
            
            if let readCompletion = readCompletion,
               let message = message {
                readCompletion(.success(message))
            } else if let message = message,
                      let record = message.records.first,
                      let account = try? JSONDecoder().decode(Account.self, from: record.payload) {
                self.completion?(.success(account))
                self.session?.alertMessage = alertMessage
                self.session?.invalidate()
            } else {
                // Initialize account if there is no account data on a tag
                let account = Account(name: "Amanda Gonzalez", balance: 8.10)
                self.updateAccount(account: account, tag: tag)
            }
        }
    }
    
    private func updateAccount(account: Account, tag: NFCNDEFTag) {
        read(tag: tag) { _ in
            self.updateAccountData(account: account, tag: tag)
        }
    }
    
    private func updateAccountData(account: Account, tag: NFCNDEFTag) {
        let jsonEncoder = JSONEncoder()
        
        guard let payloadData = try? jsonEncoder.encode(account) else {
            handleError(NFCError.invalidated(message: NFCAlertMessages.badData))
            return
        }
        
        let payload = NFCNDEFPayload(
            format: .unknown,
            type: Data(),
            identifier: Data(),
            payload: payloadData
        )
        
        let message = NFCNDEFMessage(records: [payload])
        
        tag.queryNDEFStatus { _, capacity, _ in
            guard message.length <= capacity else {
                self.handleError(NFCError.invalidPayloadSize)
                return
            }
            
            tag.writeNDEF(message) { error in
                if let error = error {
                    self.handleError(error)
                    return
                }
                
                if self.completion != nil {
                    self.read(tag: tag, alertMessage: NFCAlertMessages.successfullyWrittenToTag)
                }
            }
        }
    }
    
    private func handleError(_ error: Error) {
        session?.alertMessage = error.localizedDescription
        session?.invalidate()
    }
}

extension NFCManager: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("\(NFCAlertMessages.sessionInvalidated): \(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {}
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        if tags.count > 1 {
            let retryInterval = DispatchTimeInterval.milliseconds(500)

            session.alertMessage = NFCAlertMessages.moreThanOneTagDetected

            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval) {
                session.restartPolling()
            }
            
            return
        }

        let tag = tags.first!

        session.connect(to: tag) { error in
            if let error = error {
                self.handleError(error)
                return
            }

            tag.queryNDEFStatus { ndefStatus, _, error in
                if let error = error {
                    self.handleError(error)
                    return
                }
                
                switch (ndefStatus, self.action) {
                case (.notSupported, _):
                    session.alertMessage = NFCAlertMessages.unableToConnectToTag
                    session.invalidate()
                case (.readOnly, _):
                    session.alertMessage = NFCAlertMessages.unableToConnectToTag
                    session.invalidate()
                case (.readWrite, .readAccount):
                    self.read(tag: tag)
                case (.readWrite, .updateAccount(let account)):
                    self.updateAccountData(account: account, tag: tag)
                default:
                    session.alertMessage = NFCAlertMessages.unknownError
                    session.invalidate()
                }
            }
        }
    }
}
