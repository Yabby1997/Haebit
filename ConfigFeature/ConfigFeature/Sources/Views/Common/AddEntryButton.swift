//
//  AddEntryButton.swift
//  ConfigFeature
//
//  Created by Seunghun on 10/6/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct AddEntryButton: View {
    let action: (() -> Void)
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Color(uiColor: .secondarySystemGroupedBackground))
                HStack {
                    Label("AddNewEntry", systemImage: "plus")
                }
                .foregroundStyle(.white)
                .font(.system(size: 16, weight: .semibold))
            }
            .frame(height: 50)
        }
    }
}
