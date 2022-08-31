//
//  ContentView.swift
//  XealChallenge
//
//  Created by Goyo Vargas on 8/29/22.
//

import SwiftUI

struct ReloadFundsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.blue, .purple]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack {
                    Text("Greg Vargas")
                        .font(Font.custom(Fonts.Mont.bold, size: 24))
                        .padding()
                    
                    XCFundsAvailableView(availableFunds: 8.10)

                    XCSelectAmountPicker()

                    Spacer()

                    XCButton(text: "Pay Now")
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
