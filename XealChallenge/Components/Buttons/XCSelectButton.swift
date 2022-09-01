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
    
    var overlayColor: Color {
        isSelected ? .white : .clear
    }
    
    var backgroundOpacity: Double {
        isSelected ? 0.2 : 0.1
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
                isSelected.toggle()
            }
    }
}

struct XCSelectButton_Previews: PreviewProvider {
    static var previews: some View {
        XCSelectButton(reloadAmount: 25)
            .preferredColorScheme(.dark)
    }
}
