# Xeal iOS Challenge

## Features
- [x] Read NFC tag and displays the user's account name and balance
- [x] Select amount to add to your balance
- [x] Write user's new balance back to the NFC tag

## Technical Implementation
- SwiftUI
- Core NFC
  - Utilize NFC capabilities of the iPhone
  - Read NFC tags
  - Write to NFC tags

## Requirements
- iOS 15.5+
- Xcode 13.4.1

## How to run the app
1. Clone this repo
2. Open `XealChallenge.xcodeproj`
3. Select your device and run the the project (**NOTE:** you will need a physical device in order to use the NFC functionality of this app)

## Important note on reading/writing brand new/blank NFC tags
While working on this project I encountered an issue where `Core NFC` could not read/write to a brand new/blank NFC tag. From my experience, an NFC tag has to have already been written to (should be able to write any message to it) before it can be read/write the correct data structure for my schema.

Here was my workaround:
- Go into `ReloadFundsView.swift`
- On `line 28`, change the `return` value to `false`
- Comment out `lines 41 - 44`
- Comment out `line 50`
- On `line 54`, change the `Account model` to  `Account(name: "Amanda Gonzalez", balance: 8.10)`
- Run the app and you should be able to tap Pay Now
- Hold the new/blank tag to the phone and it should write the correct schema to the tag
- Stop the app and undo all of the changes in the code
- Rerun the app and proceed as normal


