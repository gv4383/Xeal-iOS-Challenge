//
//  ConfirmationView.swift
//  XealChallenge
//
//  Created by Goyo Vargas on 9/1/22.
//

import SwiftUI

struct ConfirmationView: View {
    let addedAmount: Int
    
    var body: some View {
        VStack(spacing: 36) {
            XCLottieView(name: Animations.checkMark, loopMode: .playOnce)
                .frame(width: 200, height: 200)
            
            Text("$\(addedAmount) \(Copy.successfullyAdded)")
                .font(Font.custom(Fonts.Mont.bold, size: 20))
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.top, 216)
        .background(.darkPurple)
        .ignoresSafeArea()
    }
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ConfirmationView(addedAmount: 25)
                .preferredColorScheme(.dark)
        }
    }
}
