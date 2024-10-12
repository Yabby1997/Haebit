//
//  GridSelectionView.swift
//  ConfigFeature
//
//  Created by Seunghun on 10/12/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

@MainActor
struct GridSelectionView<Entry, EntryView>: View where Entry: Identifiable, Entry: Equatable, EntryView: View {
    @MainActor
    fileprivate class HapticGenerator: ObservableObject {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        
        func generate() {
            generator.impactOccurred()
        }
    }
    
    @StateObject private var hapticGenerator = HapticGenerator()
    
    let entries: [Entry]
    let columnCount: Int
    @Binding var selection: Entry
    @ViewBuilder var entryView: (Entry) -> EntryView
    
    private var columns: [GridItem] {
        Array(repeating: .init(.flexible()), count: columnCount)
    }
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(entries, id: \.id) { entry in
                VStack(spacing: 14) {
                    entryView(entry)
                    CheckerIcon(isChecked: Binding(get: { selection.id == entry.id }, set: { _ in } ))
                }
                .padding(8)
                .onTapGesture {
                    selection = entry
                    hapticGenerator.generate()
                }
            }
        }
    }
}

