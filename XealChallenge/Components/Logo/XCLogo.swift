//
//  XCLogo.swift
//  XealChallenge
//
//  Created by Goyo Vargas on 8/31/22.
//

import SwiftUI

struct XCLogo: View {
    var body: some View {
        Image(systemName: SFSymbols.rhombus)
            .font(.system(size: 24))
            .padding(8)
            .overlay(
                Circle()
                    .stroke(.white.opacity(0.4), lineWidth: 2)
            )
    }
}

struct XCLogo_Previews: PreviewProvider {
    static var previews: some View {
        XCLogo()
            .preferredColorScheme(.dark)
    }
}
