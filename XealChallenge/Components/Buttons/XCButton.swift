//
//  XCButton.swift
//  XealChallenge
//
//  Created by Goyo Vargas on 8/30/22.
//

import SwiftUI

struct XCButton: View {
    let text: String
    
    var body: some View {
        Button {
            print("Button pressed...")
        } label: {
            Text(text)
                .font(Font.custom(Fonts.Mont.bold, size: 16))
                .foregroundColor(.purple)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .padding()
        .background(.white)
        .cornerRadius(12)
    }
}

struct XCButton_Previews: PreviewProvider {
    static var previews: some View {
        XCButton(text: "Pay Now")
            .preferredColorScheme(.dark)
    }
}
