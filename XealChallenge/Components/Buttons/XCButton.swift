//
//  XCButton.swift
//  XealChallenge
//
//  Created by Goyo Vargas on 8/30/22.
//

import SwiftUI

struct XCStandardButton: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        var foregroundColor: Color {
            if isEnabled {
                return configuration.isPressed ? .purple.opacity(0.5) : .purple
            } else {
                return .purple.opacity(0.5)
            }
        }
        
        var backgroundColor: Color {
            isEnabled ? .white : .white.opacity(0.5)
        }
        
        return configuration
            .label
            .font(Font.custom(Fonts.Mont.bold, size: 16))
            .foregroundColor(foregroundColor)
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
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
