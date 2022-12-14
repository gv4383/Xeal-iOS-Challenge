//
//  ContentView.swift
//  XealChallenge
//
//  Created by Goyo Vargas on 8/29/22.
//

import SwiftUI

// Workaround for reading a new/blank tag:
// On line 28, change the return value to false
// Comment out lines 41 - 44
// Comment out line 50
// On line 54, change the Account model to  Account(name: "Amanda Gonzalez", balance: 8.10)
// Run the app and you should be able to tap Pay Now
// Hold the new/blank tag to the phone and it should write the correct schema to the tag
// Stop the app and undo all of the changes in the code
// Rerun the app and proceed as normal

struct ReloadFundsView: View {
    @State private var account: Account?
    @State private var selectedReloadAmount  = 0
    @State private var isPayNowButtonLoading = false
    @State private var isShowingConfirmationView = false
    
    private var isButtonDisabled: Bool {
        if account == nil {
            return true
        } else {
            if selectedReloadAmount == 0 {
                return true
            }
            
            return false
        }
    }
    
    private func updateAccount() {
        isPayNowButtonLoading = true
        
        guard let account = account else {
            isPayNowButtonLoading = false
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isPayNowButtonLoading = false
        }
        
        let newBalance = account.balance + Double(selectedReloadAmount)
        
        NFCManager.performAction(
            .updateAccount(
                account: Account(name: account.name, balance: newBalance)
            )
        ) { account in
            self.isPayNowButtonLoading = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.account = try? account.get()
                self.isShowingConfirmationView = true
                self.isPayNowButtonLoading = false
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.purpleBlue, .violet]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 16) {
                    Text(account?.name ?? "")
                        .font(Font.custom(Fonts.Mont.bold, size: 24))
                        .padding()
                    
                    VStack(spacing: 48) {
                        XCFundsAvailableView(availableFunds: account?.balance ?? 0.0)
                            .onTapGesture {
                                NFCManager.performAction(.readAccount) { account in
                                    self.account = try? account.get()
                                }
                            }
                        
                        XCSelectAmountPicker(selectedReloadAmount: $selectedReloadAmount)
                    }
                    
                    NavigationLink(
                        destination: ConfirmationView(addedAmount: selectedReloadAmount),
                        isActive: $isShowingConfirmationView
                    ) {
                        EmptyView()
                    }

                    Spacer()
                    
                    XCButton(isLoading: $isPayNowButtonLoading, text: Copy.payNow) {
                        updateAccount()
                    }
                    .disabled(isButtonDisabled)
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}

struct ReloadFundsView_Previews: PreviewProvider {
    static var previews: some View {
        ReloadFundsView()
            .preferredColorScheme(.dark)
    }
}
