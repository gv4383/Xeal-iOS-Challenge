//
//  XCFundsAvailableView.swift
//  XealChallenge
//
//  Created by Goyo Vargas on 8/31/22.
//

import SwiftUI

struct XCFundsAvailableView: View {
    let availableFunds: Double
    var formattedAvailableFunds: String {
        String(format: "$%.2f", availableFunds)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            VStack {
                XCLogo()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(formattedAvailableFunds)
                    .font(Font.custom(Fonts.Mont.bold, size: 24))
                
                Text(Copy.fundsAvailable)
                    .font(Font.custom(Fonts.Mont.bold, size: 12))
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.white.opacity(0.2), lineWidth: 2)
        )
    }
}

struct XCFundsAvailableView_Previews: PreviewProvider {
    static var previews: some View {
        XCFundsAvailableView(availableFunds: 8.10)
            .preferredColorScheme(.dark)
    }
}
