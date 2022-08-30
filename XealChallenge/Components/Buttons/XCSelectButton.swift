//
//  SelectButton.swift
//  XealChallenge
//
//  Created by Goyo Vargas on 8/29/22.
//

import SwiftUI

struct XCSelectButton: View {
    let reloadAmount: Int
    
    var body: some View {
        Text("$\(reloadAmount)")
            .font(Font.custom(Fonts.Mont.bold, size: 32))
            .padding()
            .background(.gray.opacity(0.3))
            .cornerRadius(12, antialiased: true)
    }
}

struct XCSelectButton_Previews: PreviewProvider {
    static var previews: some View {
        XCSelectButton(reloadAmount: 25)
            .preferredColorScheme(.dark)
    }
}
