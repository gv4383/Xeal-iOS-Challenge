//
//  NFCManager.swift
//  XealChallenge
//
//  Created by Goyo Vargas on 9/1/22.
//

import Foundation
import CoreNFC

final class NFCManager: NSObject, ObservableObject, NFCNDEFReaderSessionDelegate {
    var nfcData = ""
    var nfcSession: NFCNDEFReaderSession?
    
    func scanTag(nfcData: String) {
        self.nfcData = nfcData
        nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        nfcSession?.alertMessage = "Hold iPhone near an NFC card."
        nfcSession?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {}
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {}
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        let str = nfcData
        
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
            if error != nil {
                session.alertMessage = "Unable to connect to NFC tag."
                session.invalidate()
                
                return
            }
            
            tag.queryNDEFStatus { ndefStatus, capacity, error in
                guard error == nil else {
                    session.alertMessage = "Unable to connect to NFC tag."
                    session.invalidate()
                    
                    return
                }
                switch ndefStatus {
                case .notSupported:
                    session.alertMessage = "Unable to connect to NFC tag."
                    session.invalidate()
                case .readWrite:
                    tag.writeNDEF(.init(records: [NFCNDEFPayload.wellKnownTypeURIPayload(string: "\(str)")!])) { error in
                        if error != nil {
                            session.alertMessage = "Write NDEF message failed."
                        } else {
                            session.alertMessage = "You have successfully written to your tag!"
                        }
                        
                        session.invalidate()
                    }
                case .readOnly:
                    session.alertMessage = "Unable to connect to NFC tag."
                    session.invalidate()
                @unknown default:
                    session.alertMessage = "Unknown error"
                    session.invalidate()
                }
            }
        }
    }
}
