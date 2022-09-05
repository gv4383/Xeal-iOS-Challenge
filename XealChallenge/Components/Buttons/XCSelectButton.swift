//
//  SelectButton.swift
//  XealChallenge
//
//  Created by Goyo Vargas on 8/29/22.
//

import SwiftUI

struct XCSelectButton: View {
    let reloadAmount: Int
    
    @State private var isSelected = false
    @Binding var selectedReloadAmount: Int
    
    private var isUsingSelectedStyling: Bool {
        isSelected && reloadAmount == selectedReloadAmount
    }
    
    private var overlayColor: Color {
        isUsingSelectedStyling ? .white : .clear
    }
    
    private var backgroundOpacity: Double {
        isUsingSelectedStyling ? 0.2 : 0.1
    }
    
    var body: some View {
        Text("$\(reloadAmount)")
            .font(Font.custom(Fonts.Mont.bold, size: 28))
            .padding(.vertical)
            .padding(.horizontal, 24)
            .background(.white.opacity(backgroundOpacity))
            .cornerRadius(16, antialiased: true)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(overlayColor, lineWidth: 2)
            )
            .onTapGesture {
                if reloadAmount != selectedReloadAmount {
                    isSelected = false
                    selectedReloadAmount = reloadAmount
                } else {
                    selectedReloadAmount = 0
                }
                
                isSelected.toggle()
            }
    }
}

struct XCSelectButton_Previews: PreviewProvider {
    static var previews: some View {
        XCSelectButton(reloadAmount: 25, selectedReloadAmount: .constant(25))
            .preferredColorScheme(.dark)
    }
}
