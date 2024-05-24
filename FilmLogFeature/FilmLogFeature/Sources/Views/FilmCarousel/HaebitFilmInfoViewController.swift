//
//  HaebitFilmInfoViewController.swift
//  FilmLogFeature
//
//  Created by Seunghun on 5/24/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct HaebitFilmInfoView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: HaebitFilmInfoViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(viewModel.date.description)
                if let coordinate = viewModel.coordinate {
                    Text("Latitude: \(coordinate.latitude)")
                    Text("Longitude: \(coordinate.longitude)")
                }
                Text(viewModel.focalLength.title)
                Text(viewModel.iso.description)
                Text(viewModel.shutterSpeed.description)
                Text(viewModel.aperture.description)
                Text(viewModel.memo)
            }
                .navigationTitle("Info")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
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
    }
    
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
