//
//  SelectAmountPicker.swift
//  XealChallenge
//
//  Created by Goyo Vargas on 8/30/22.
//

import SwiftUI

struct XCSelectAmountPicker: View {
    @Binding var selectedReloadAmount: Int
    
    private let amounts = [10, 25, 50]
    
    var body: some View {
        VStack {
            HStack {
                Text(Copy.selectAmount)
                    .font(Font.custom(Fonts.Mont.bold, size: 14))
                    .opacity(0.6)
            }
            .padding()
            
            HStack(spacing: 16) {
                ForEach(amounts, id: \.self) { amount in
                    XCSelectButton(reloadAmount: amount, selectedReloadAmount: $selectedReloadAmount)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
}

struct XCSelectAmountPicker_Previews: PreviewProvider {
    static var previews: some View {
        XCSelectAmountPicker(selectedReloadAmount: .constant(25))
            .preferredColorScheme(.dark)
    }
}
