//
//  HaebitConfigHeaderSection.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/27/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct HaebitConfigHeaderSection: View {
    @Binding var navigationPath: NavigationPath
    @StateObject var viewModel: HaebitConfigViewModel
    
    var body: some View {
        Section {} header: {
            ZStack {
                VStack(spacing: 8) {
                    Spacer()
                    HStack {
                        Text(viewModel.currentHeaderType.title)
                            .font(.system(size: 40, weight: .bold, design: .serif))
                        Spacer()
                    }
                    HStack {
                        Text(viewModel.currentHeaderType.description)
                            .font(.system(size: 16, weight: .semibold, design: .serif))
                        Spacer()
                    }
                }
            }
            .animation(.easeInOut(duration: 1), value: viewModel.currentHeaderType)
            .listRowInsets(.init(top: .zero, leading: 8, bottom: .zero, trailing: 8))
            .frame(height: 300)
            .onTapGesture(perform: handleTapGesture)
        }
    }
    
    func handleTapGesture() {
        switch viewModel.currentHeaderType {
        case .tipJar: navigationPath.append(NavigatablePages.tipJar)
        case .reviewRequest: viewModel.didTapReview()
        case .filmCanister: navigationPath.append(NavigatablePages.filmCanister)
        }
    }
}

extension HeaderType {
    var title: LocalizedStringKey {
        switch self {
        case .tipJar: return "tipJarTitle"
        case .reviewRequest: return "reviewRqeuestTitle"
        case .filmCanister: return "filmCanisterTitle"
        }
    }
    
    var description: LocalizedStringKey {
        switch self {
        case .tipJar: return "tipJarDescription"
        case .reviewRequest: return "reviewRequestDescription"
        case .filmCanister: return "filmCanisterDescription"
        }
    }
}
