//
//  NFCManager.swift
//  XealChallenge
//
//  Created by Goyo Vargas on 9/1/22.
//

import Foundation
import CoreNFC

final class NFCManager: NSObject, ObservableObject {
    enum NFCAction {
        case readAccount
        case updateAccount(accountName: String)
        
        var alertMessage: String {
            switch self {
            case .readAccount:
                return "Place iPhone near NFC tag to read account details."
            case .updateAccount(let accountName):
                return "Place iPhone near NFC tag to update account for \(accountName)."
            }
        }
    }
    
    private static let shared = NFCManager()
    private var action: NFCAction = .readAccount
    private var session: NFCNDEFReaderSession?
    
    static func performAction(_ action: NFCAction) {
        shared.action = action
        shared.session = NFCNDEFReaderSession(delegate: shared.self, queue: nil, invalidateAfterFirstRead: true)
        shared.session?.alertMessage = action.alertMessage
        shared.session?.begin()
    }
    
    private func writeUserData(name: String, with tag: NFCNDEFTag) {
        var records = [NFCNDEFPayload]()
        let payload = NFCNDEFPayload.wellKnownTypeTextPayload(string: name, locale: .current)!
        
        records.append(payload)
        
        let message = NFCNDEFMessage(records: records)
        
        tag.writeNDEF(message) { error in
            if let error = error {
                self.handleError(error)
                return
            }
            
            self.session?.alertMessage = "You have successfully written to your tag!"
            self.session?.invalidate()
        }
    }
    
    private func readUserData(from tag: NFCNDEFTag) {
        tag.readNDEF { message, error in
            if let error = error {
                self.handleError(error)
                return
            }
            
            guard let message = message else {
                self.session?.alertMessage = "Could not read tag data."
                self.session?.invalidate()
                return
            }
            
            guard
                let record = message.records.first,
                let name = record.wellKnownTypeTextPayload().0
            else {
                return
            }
            
            print("NAME: \(name)")
            
            self.session?.alertMessage = "Tag was read."
            self.session?.invalidate()
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
                    self.readUserData(from: tag)
                case (.readWrite, .updateAccount(let accountName)):
                    self.writeUserData(name: accountName, with: tag)
                default:
                    session.alertMessage = "Unknown error"
                    session.invalidate()
                }
            }
        }
    }
}
