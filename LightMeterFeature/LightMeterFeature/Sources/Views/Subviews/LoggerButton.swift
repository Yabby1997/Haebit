//
//  LoggerButton.swift
//  HaebitDev
//
//  Created by Seunghun on 1/24/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels
import HaebitUI

struct LoggerButton: View {
    @StateObject var viewModel: HaebitLightMeterViewModel
    let action: (() -> Void)?
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                action?()
            } label: {
                Image(asset: viewModel.filmCanister.image)
                    .resizable()
                    .scaledToFit()
            }
            .frame(height: 60)
            .rotationEffect(viewModel.orientation.angle)
            .animation(.easeInOut, value: viewModel.orientation)
        }
    }
}

fileprivate extension FilmCanister {
    var image: LightMeterFeatureImages {
        switch self {
        case .kodakUltramax400:
            return LightMeterFeatureAsset.kodakUltramax400
        case .kodakColorPlus200:
            return LightMeterFeatureAsset.kodakColor200
        case .kodakGold200:
            return LightMeterFeatureAsset.kodakGold200
        case .kodakE100:
            return LightMeterFeatureAsset.kodakE100
        case .kodakPortra800:
            return LightMeterFeatureAsset.kodakPortra800
        case .cinestill800T:
            return LightMeterFeatureAsset.cinestill800T
        case .cinestill400D:
            return LightMeterFeatureAsset.cinestill400D
        case .cinestill50D:
            return LightMeterFeatureAsset.cinestill50D
        case .ilfordXP2:
            return LightMeterFeatureAsset.ilfordxp2super
        case .fujiXtra400:
            return LightMeterFeatureAsset.fujiFilmXTra400
        }
    }
}
