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
    @FocusState var isMemoFocused: Bool
    
    @State var isDeleteConfirmationDialogPresented = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                MapInfoView(viewModel: viewModel)
                    .padding(.horizontal, 12)
                Divider().padding(.horizontal, 12)
                VStack(alignment: .center, spacing: 8) {
                    Text("촬영일")
                        .font(.system(size: 12, weight: .semibold))
                    HStack {
                        Text(viewModel.date, style: .date)
                        Text(viewModel.date, style: .time)
                    }
                    .animation(.easeInOut, value: viewModel.date)
                    .font(.system(size: 18, weight: .bold, design: .serif))
                }
                .contentTransition(.numericText())
                .onTapGesture {
                    isMemoFocused = false
                    isDatePickerPresented = true
                }
                .padding(.horizontal, 20)
                Divider().padding(.horizontal, 12)
                HStack(alignment: .center) {
                    VStack(alignment: .center, spacing: 4) {
                        Text("조리개")
                            .font(.system(size: 12, weight: .semibold))
                        Text(viewModel.aperture.title)
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .lineLimit(1)
                            .animation(.easeInOut, value: viewModel.aperture)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        isMemoFocused = false
                        isApertureInputViewPresented = true
                    }
                    VStack(alignment: .center, spacing: 4) {
                        Text("셔터속도")
                            .font(.system(size: 12, weight: .semibold))
                        Text(viewModel.shutterSpeed.description)
                            .font(.system(size: 16, weight: .bold, design: .serif))
                            .lineLimit(1)
                            .animation(.easeInOut, value: viewModel.shutterSpeed)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        isMemoFocused = false
                        isShutterSpeedInputViewPresented = true
                    }
                    VStack(alignment: .center, spacing: 4) {
                        Text("초점거리")
                            .font(.system(size: 12, weight: .semibold))
                        Text(viewModel.focalLength.title)
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .lineLimit(1)
                            .animation(.easeInOut, value: viewModel.focalLength)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        isMemoFocused = false
                        isFocalLengthInputViewPresented = true
                    }
                    VStack(alignment: .center, spacing: 4) {
                        Text("감도")
                            .font(.system(size: 12, weight: .semibold))
                        Text(viewModel.iso.title)
                            .font(.system(size: 16, weight: .bold, design: .serif))
                            .lineLimit(1)
                            .animation(.easeInOut, value: viewModel.iso)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        isMemoFocused = false
                        isIsoInputViewPresented = true
                    }
                }
                .padding(.horizontal, 12)
                .contentTransition(.numericText())
                Divider().padding(.horizontal, 12)
                TextField("메모", text: $viewModel.memo, axis: .vertical)
                    .focused($isMemoFocused)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .font(.system(size: 16, weight: .bold, design: .serif))
                    .frame(maxHeight: .infinity, alignment: .top)
            }
            .bottomSheet(isPresented: $isDatePickerPresented) {
                DatePicker(selection: $viewModel.date) {}
                    .datePickerStyle(.graphical)
                    .preferredColorScheme(.dark)
                    .padding(20)
            }
            .bottomSheet(isPresented: $isApertureInputViewPresented) {
                ApertureInputView(value: $viewModel.aperture)
            }
            .bottomSheet(isPresented: $isShutterSpeedInputViewPresented) {
                ShutterSpeedInputView(value: $viewModel.shutterSpeed)
            }
            .bottomSheet(isPresented: $isFocalLengthInputViewPresented) {
                FocalLengthInputView(value: $viewModel.focalLength)
            }
            .bottomSheet(isPresented: $isIsoInputViewPresented) {
                IsoInputView(value: $viewModel.iso)
            }
            .preferredColorScheme(.dark)
            .navigationBarTitleDisplayMode(.inline)
            .scrollIndicators(.hidden)
            .navigationTitle("Info")
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button {
                        isDeleteConfirmationDialogPresented = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                    }
                    Button {
                        viewModel.undo()
                    } label: {
                        Image(systemName: "arrow.uturn.backward")
                    }
                    .foregroundStyle(.white)
                    .opacity(viewModel.isEdited ? 1.0 : .zero)
                    .animation(.easeInOut, value: viewModel.isEdited)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .foregroundStyle(.white)
                }
            }
            .confirmationDialog("", isPresented: $isDeleteConfirmationDialogPresented, titleVisibility: .hidden) {
                Button("삭제하기", role: .destructive) {
                    Task {
                        try? await viewModel.delete()
                        dismiss()
                    }
                }
                .preferredColorScheme(.dark)
            }
        }
    }
}

@MainActor
final class HaebitFilmInfoViewController: UIHostingController<HaebitFilmInfoView> {
    init(viewModel: HaebitFilmInfoViewModel) {
        super.init(rootView: HaebitFilmInfoView(viewModel: viewModel))
        overrideUserInterfaceStyle = .dark
        modalPresentationStyle = .fullScreen
    }
    
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
