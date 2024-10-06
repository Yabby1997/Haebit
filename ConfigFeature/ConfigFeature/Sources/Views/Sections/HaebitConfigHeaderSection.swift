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
    var title: String {
        switch self {
        case .tipJar: return "Having fun with illumeter?"
        case .reviewRequest: return "149 cuts with illumeter"
        case .filmCanister: return "Wanna try fresh look? "
        }
    }
    
    var description: String {
        switch self {
        case .tipJar: return "If so, consider to buy me a roll of film. I'm a film photographer as well."
        case .reviewRequest: return "How about leaving a review on the AppStore? It will help me to improve the app."
        case .filmCanister: return "You can customize some apperances like film canister on the bottom right corner!"
        }
    }
}
