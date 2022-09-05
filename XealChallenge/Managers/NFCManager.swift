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
                return "NFC Reader Not Available"
            case .invalidated(let message):
                return message
            case .invalidPayloadSize:
                return "NDEF payload size exceeds the tag limit"
            }
        }
    }
    
    enum NFCAction {
        case readAccount
        case updateAccount(account: Account)
        
        var alertMessage: String {
            switch self {
            case .readAccount:
                return "Place iPhone near NFC tag to read account details."
            case .updateAccount(let account):
                return "Place iPhone near NFC tag to update account for \(account.name)."
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
    
    private func read(
        tag: NFCNDEFTag,
        alertMessage: String = "Tag was read.",
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
                self.session?.alertMessage = "Could not decode tag data."
                self.session?.invalidate()
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
            handleError(NFCError.invalidated(message: "Bad data"))
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
                    self.read(tag: tag, alertMessage: "You have successfully written to your tag!")
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
        print("The session was invalidated: \(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {}
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        if tags.count > 1 {
            let retryInterval = DispatchTimeInterval.milliseconds(500)

            session.alertMessage = "More than one NFC tag detected. Please try again."

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
                    session.alertMessage = "Unable to connect to NFC tag."
                    session.invalidate()
                case (.readOnly, _):
                    session.alertMessage = "Unable to connect to NFC tag."
                    session.invalidate()
                case (.readWrite, .readAccount):
                    self.read(tag: tag)
                case (.readWrite, .updateAccount(let account)):
                    self.updateAccountData(account: account, tag: tag)
                default:
                    session.alertMessage = "Unknown error"
                    session.invalidate()
                }
            }
        }
    }
}
