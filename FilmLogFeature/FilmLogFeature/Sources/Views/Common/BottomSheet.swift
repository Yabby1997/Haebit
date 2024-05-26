//
//  BottomSheet.swift
//  FilmLogFeature
//
//  Created by Seunghun on 5/26/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct BottomSheet<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    @ViewBuilder let sheetContent: () -> SheetContent
    @State var detentHeight: CGFloat = .zero
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                sheetContent()
                    .readHeight()
                    .onPreferenceChange(HeightPreferenceKey.self) { height in
                        guard let height else { return }
                        detentHeight = height
                    }
                    .highPriorityGesture(DragGesture())
                    .presentationDetents([.height(detentHeight)])
            }
    }
}

extension View {
    func bottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(BottomSheet(isPresented: isPresented, sheetContent: content))
    }
}

fileprivate struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat?

    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        guard let nextValue = nextValue() else { return }
        value = nextValue
    }
}

private struct HeightReader: ViewModifier {
    private var heightReadingView: some View {
        GeometryReader { proxy in
            Color.clear.preference(key: HeightPreferenceKey.self, value: proxy.size.height)
        }
    }

    func body(content: Content) -> some View {
        content.background(heightReadingView)
    }
}

extension View {
    fileprivate func readHeight() -> some View {
        modifier(HeightReader())
    }
}
