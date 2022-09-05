//
//  ContentView.swift
//  XealChallenge
//
//  Created by Goyo Vargas on 8/29/22.
//

import SwiftUI

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
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.purpleBlue, .violet]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack {
                    Text(account?.name ?? "")
                        .font(Font.custom(Fonts.Mont.bold, size: 24))
                        .padding()
                    
                    XCFundsAvailableView(availableFunds: account?.balance ?? 0.0)
                        .onTapGesture {
                            NFCManager.performAction(.readAccount) { account in
                                self.account = try? account.get()
                            }
                        }

                    XCSelectAmountPicker(selectedReloadAmount: $selectedReloadAmount)
                    
                    NavigationLink(destination: ConfirmationView(addedAmount: selectedReloadAmount), isActive: $isShowingConfirmationView) {
                        EmptyView()
                    }

                    Spacer()
                    
                    XCButton(isLoading: $isPayNowButtonLoading, text: Copy.payNow) {
                        isPayNowButtonLoading = true
                        
                        guard let account = account else {
                            isPayNowButtonLoading = false
                            return
                        }
                        
                        let newBalance = account.balance + Double(selectedReloadAmount)
                        
                        NFCManager.performAction(
                            .updateAccount(
                                account: Account(name: account.name, balance: newBalance)
                            )
                        ) { account in
                            self.account = try? account.get()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                self.isShowingConfirmationView = true
                                self.isPayNowButtonLoading = false
                            }
                        }
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
