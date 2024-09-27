//
//  HaebitConfigHeaderSection.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/27/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct HaebitConfigHeaderSection: View {
    var body: some View {
        Section {} header: {
            ZStack {
                VStack(spacing: 8) {
                    Spacer()
                    HStack {
                        Text("Having fun with illumeter?")
                            .font(.system(size: 40, weight: .bold, design: .serif))
                        Spacer()
                    }
                    HStack {
                        Text("If so, consider to buy me a roll of film 🎞️. It would be very pleasant for me")
                            .font(.system(size: 16, weight: .semibold, design: .serif))
                        Spacer()
                    }
                }
            }
            .frame(height: 300)
            .onTapGesture {
                print("!!")
            }
        }
    }
}

#Preview {
    HaebitConfigHeaderSection()
}
