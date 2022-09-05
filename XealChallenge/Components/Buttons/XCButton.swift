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
                return configuration.isPressed ? .darkPurple.opacity(0.5) : .darkPurple
            } else {
                return .darkPurple.opacity(0.4)
            }
        }
        
        var backgroundColor: Color {
            isEnabled ? .white : .white.opacity(0.4)
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
    @Binding var isLoading: Bool
    let text: String
    let action: () -> Void
    
    
    var body: some View {
        Button {
            action()
        } label: {
            if isLoading {
                XCLottieView(name: Animations.purpleSpinner, loopMode: .loop)
                    .frame(width: 16, height: 16)
            } else {
                Text(text)
            }
        }
        .buttonStyle(XCStandardButton())
        .disabled(isLoading)
    }
}

struct XCButton_Previews: PreviewProvider {
    private static func previewFunc() {}
    
    static var previews: some View {
        XCButton(isLoading: .constant(false), text: "Pay Now", action: previewFunc)
            .preferredColorScheme(.dark)
    }
}
