//
//  Constants.swift
//  XealChallenge
//
//  Created by Goyo Vargas on 8/29/22.
//

import Foundation

struct Fonts {
    struct Mont {
        static let black = "Mont-Black"
        static let bold = "Mont-Bold"
        static let extraLight = "Mont-ExtraLight"
        static let light = "Mont-Light"
        static let regular = "Mont-Regular"
        static let semiBold = "Mont-SemiBold"
        static let thin = "Mont-Thin"
    }
}

struct Copy {
    static let fundsAvailable = "FUNDS AVAILABLE"
    static let selectAmount = "SELECT RELOAD AMOUNT"
    static let payNow = "Pay Now"
    static let successfullyAdded = "Successfully Added!"
}

struct SFSymbols {
    static let rhombus = "rhombus"
}

struct Animations {
    static let checkMark = "checkMark"
    static let smallSpinner = "smallSpinner"
    static let purpleSpinner = "purpleSpinner"
}

struct NFCAlertMessages {
    static let readerNotAvailable = "NFC reader not available."
    static let payloadSizeTooBig = "NDEF payload size exceeds the tag limit."
    static let readAccountDetails = "Place iPhone near NFC tag to read account details."
    static let updateAccount = "Place iPhone near NFC tag to update account for"
    static let tagWasRead = "NFC tag was read."
    static let badData = "Bad data."
    static let successfullyWrittenToTag = "You have successfully written to your tag!"
    static let sessionInvalidated = "The session was invalidated"
    static let moreThanOneTagDetected = "More than one NFC tag detected. Please try again."
    static let unableToConnectToTag = "Unable to connect to NFC tag."
    static let unknownError = "An unknown error occurred while reading NFC tag."
}
