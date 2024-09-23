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
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .highPriorityGesture(DragGesture())
                    .background {
                        GeometryReader { proxy in
                            Color.clear
                                .onAppear { detentHeight = proxy.size.height }
                                .onChange(of: proxy.size) { detentHeight = $0.height }
                        }
                    }
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
