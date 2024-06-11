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
                        isMemoEditing = false
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
                            isMemoEditing = false
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
                            isMemoEditing = false
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
                            isMemoEditing = false
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
                            isMemoEditing = false
                            isIsoInputViewPresented = true
                        }
                    }
                    .padding(.horizontal, 12)
                    .contentTransition(.numericText())
                    Divider().padding(.horizontal, 12)
                    MemoView(text: $viewModel.memo, isEditing: $isMemoEditing, placeholder: "메모", font: .systemFont(ofSize: 16, weight: .bold, design: .serif))
                        .padding(.horizontal, 12)
                }
            }
            .bottomSheet(isPresented: $isDatePickerPresented) {
                DatePicker(selection: $viewModel.date) {}
                    .datePickerStyle(.graphical)
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
            .confirmationDialog("정말 삭제하시겠습니까?", isPresented: $isDeleteConfirmationDialogPresented,  titleVisibility: .visible) {
                Button("삭제하기", role: .destructive) {
                    Task {
                        try? await viewModel.didTapDelete()
                        dismiss()
                    }
                }
            }
            .confirmationDialog("변경사항이 있습니다.", isPresented: $isUpdateConfirmationDialogPresented, titleVisibility: .visible) {
                Button("변경사항 폐기", role: .destructive) {
                    dismiss()
                }
                Button("저장", role: .none) {
                    Task {
                        try? await viewModel.didTapSave()
                        dismiss()
                    }
                }
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
