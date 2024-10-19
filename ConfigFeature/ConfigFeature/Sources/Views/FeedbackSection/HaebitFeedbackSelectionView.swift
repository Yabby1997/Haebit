//
//  HaebitFeedbackSelectionView.swift
//  ConfigFeature
//
//  Created by Seunghun on 10/7/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels

struct HaebitFeedbackSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selection: FeedbackStyle?
    @Binding var isPresented: Bool
    
    init(selection: Binding<FeedbackStyle>, isPresented: Binding<Bool>) {
        self._selection = Binding(
            get: { selection.wrappedValue },
            set: { newValue in
                guard let newValue else { return }
                selection.wrappedValue = newValue
            }
        )
        self._isPresented = isPresented
    }

    var body: some View {
        List(FeedbackStyle.allCases, id: \.self, selection: $selection) { feedbackStyle in
            HStack {
                Text(feedbackStyle.description)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if selection == feedbackStyle {
                    Spacer()
                    Image.checkMark
                        .foregroundStyle(.yellow)
                }
            }
            .font(.system(size: 16, weight: .semibold))
            .listRowBackground(Color(UIColor.secondarySystemGroupedBackground))
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .scrollIndicators(.hidden)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isPresented = false
                } label: {
                    Image.xmark
                        .foregroundStyle(.white)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image.arrowBackward
                        .foregroundStyle(.white)
                }
            }
        }
    }
}
