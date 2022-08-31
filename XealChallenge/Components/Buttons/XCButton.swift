//
//  XCButton.swift
//  XealChallenge
//
//  Created by Goyo Vargas on 8/30/22.
//

import SwiftUI

struct XCStandardButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(Font.custom(Fonts.Mont.bold, size: 16))
            .foregroundColor(configuration.isPressed ? .purple.opacity(0.5) : .purple)
            .frame(maxWidth: .infinity)
            .padding()
            .background(.white)
            .cornerRadius(12)
    }
}

struct XCButton: View {
    let text: String
    
    var body: some View {
        Button(text) {
            print("Button pressed...")
        }
        .buttonStyle(XCStandardButton())
    }
}

struct XCButton_Previews: PreviewProvider {
    static var previews: some View {
        XCButton(text: "Pay Now")
            .preferredColorScheme(.dark)
    }
}
