//
//  HaebitLoggerView.swift
//  HaebitDev
//
//  Created by Seunghun on 1/24/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct HaebitLoggerView: View {
    let closeButtonAction: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("로거")
            }
            .navigationTitle("Logger")
            .toolbar {
                Button {
                    closeButtonAction()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
    }
}

#Preview {
    HaebitLoggerView {
        print("close")
    }
}
