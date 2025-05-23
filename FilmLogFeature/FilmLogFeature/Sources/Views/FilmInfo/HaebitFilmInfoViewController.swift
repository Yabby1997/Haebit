//
//  HaebitFilmInfoViewController.swift
//  FilmLogFeature
//
//  Created by Seunghun on 5/24/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

@MainActor
struct HaebitFilmInfoView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: HaebitFilmInfoViewModel
    
    @State var isApertureInputViewPresented = false
    @State var isShutterSpeedInputViewPresented = false
    @State var isFocalLengthInputViewPresented = false
    @State var isIsoInputViewPresented = false
    @State var isDatePickerPresented = false
    @State var isMemoEditing = false
    
    @State var isDeleteConfirmationDialogPresented = false
    @State var isUpdateConfirmationDialogPresented = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    VStack(spacing: 12) {
                        MapInfoView(viewModel: viewModel)
                            .padding(.horizontal, 12)
                        Divider().padding(.horizontal, 12)
                        DateInfoView(date: $viewModel.date)
                        Divider().padding(.horizontal, 12)
                        HStack(alignment: .center) {
                            ApertureInfoView(value: $viewModel.aperture)
                            ShutterSpeedInfoView(value: $viewModel.shutterSpeed)
                            ISOInfoView(value: $viewModel.iso)
                            FocalLengthInfoView(value: $viewModel.focalLength)
                        }
                        .padding(.horizontal, 12)
                        .contentTransition(.numericText())
                    }
                    .simultaneousGesture(TapGesture().onEnded { isMemoEditing = false })
                    Divider().padding(.horizontal, 12)
                    MemoView(
                        text: $viewModel.memo,
                        isEditing: $isMemoEditing,
                        placeholderResource: .memoViewPlaceholder,
                        font: .systemFont(ofSize: 16, weight: .bold, design: .serif)
                    )
                    .padding(.horizontal, 12)
                }
            }
            .navigationTitle(Text(.filmInfoViewTitle))
            .navigationBarTitleDisplayMode(.inline)
            .scrollDismissesKeyboard(.interactively)
            .scrollIndicators(.hidden)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button {
                        isDeleteConfirmationDialogPresented = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                    }
                    Button {
                        viewModel.didTapUndo()
                    } label: {
                        Image(systemName: "arrow.uturn.backward")
                    }
                    .foregroundStyle(.white)
                    .opacity(viewModel.isEdited ? 1.0 : .zero)
                    .animation(.easeInOut, value: viewModel.isEdited)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if viewModel.isEdited {
                            isUpdateConfirmationDialogPresented = true
                        } else {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .foregroundStyle(.white)
                }
            }
            .confirmationDialog("", isPresented: $isDeleteConfirmationDialogPresented) {
                Button(role: .destructive) {
                    Task {
                        try? await viewModel.didTapDelete()
                        dismiss()
                    }
                } label: {
                    Text(.filmInfoViewDeleteConfirmationDelete)
                }
                .foregroundStyle(.red)
            } message: {
                Text(.filmInfoViewDeleteConfirmationTitle)
            }
            .confirmationDialog("", isPresented: $isUpdateConfirmationDialogPresented) {
                Button(role: .destructive) {
                    dismiss()
                } label: {
                    Text(.filmInfoViewUpdateConfirmationAbandon)
                }
                Button {
                    Task {
                        try? await viewModel.didTapSave()
                        dismiss()
                    }
                } label: {
                    Text(.filmInfoViewUpdateConfirmationUpdate)
                }
            } message: {
                Text(.filmInfoViewUpdateConfirmationTitle)
            }
        }
    }
}

@MainActor
final class HaebitFilmInfoViewController: UIHostingController<HaebitFilmInfoView> {
    init(viewModel: HaebitFilmInfoViewModel) {
        super.init(rootView: HaebitFilmInfoView(viewModel: viewModel))
        modalPresentationStyle = .fullScreen
    }
    
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
