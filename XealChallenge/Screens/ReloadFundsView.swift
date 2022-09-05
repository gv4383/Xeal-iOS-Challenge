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
                    
                    Text("\(selectedReloadAmount)")
                        .font(Font.custom(Fonts.Mont.bold, size: 24))
                        .padding()

                    Spacer()
                    
                    XCButton(text: Copy.payNow) {
                        NFCManager.performAction(
                            .updateAccount(
                                account: Account(name: "Amanda Gonzalez", balance: 8.10)
                            )
                        ) { account in
                            self.account = try? account.get()
                        }
                    }
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
