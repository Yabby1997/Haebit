//
//  MapView.swift
//  FilmLogFeature
//
//  Created by Seunghun on 5/25/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct MapInfoView<ViewModel>: View where ViewModel: MapInfoViewModelProtocol {
    @StateObject var viewModel: ViewModel
    @State var isPresenting = false
    
    var body: some View {
        ZStack {
            VStack(spacing: .zero) {
                MapPicker(coordinate: $viewModel.coordinate)
                    .frame(height: 175)
                ZStack {
                    Color(uiColor: UIColor(red: 29 / 255, green: 29 / 255, blue: 29 / 255, alpha: 1.0))
                    HStack {
                        Text("위치 제거")
                            .foregroundStyle(.yellow)
                            .onTapGesture { viewModel.coordinate = nil }
                            .opacity(viewModel.coordinate == nil ? .zero : 1.0)
                            .animation(.easeInOut, value: viewModel.coordinate)
                        Spacer()
                        HStack(spacing: 4) {
                            Text("위치 검색")
                                .foregroundStyle(.white)
                            Image(systemName: "chevron.right")
                                .resizable()
                                .frame(width: 8, height: 10)
                        }
                        .onTapGesture {
                            isPresenting = true
                        }
                    }
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                }
                .frame(height: 25)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .sheet(isPresented: $isPresenting) {
            MapInfoSearchView(viewModel: viewModel)
                .presentationDetents([.height(150)])
        }
    }
}
