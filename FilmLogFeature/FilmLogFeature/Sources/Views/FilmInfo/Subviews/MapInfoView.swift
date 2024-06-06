//
//  MapView.swift
//  FilmLogFeature
//
//  Created by Seunghun on 5/25/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import HaebitCommonModels
import SwiftUI
import _MapKit_SwiftUI
import Portolan

extension Coordinate {
    var pin: Pin { Pin(coordinate: self) }
    var region: MKCoordinateRegion { .init(center: clLocationCoordinate2D, latitudinalMeters: 10_000, longitudinalMeters: 10_000) }
}

struct Pin: Identifiable {
    let id = UUID()
    let coordinate: Coordinate
}

struct MapInfoView<ViewModel>: View where ViewModel: MapInfoViewModelProtocol {
    @StateObject var viewModel: ViewModel
    @State var isPresenting = false

    var body: some View {
        VStack(spacing: .zero) {
            if let coordinate = viewModel.coordinate {
                Map(
                    coordinateRegion: .constant(coordinate.region),
                    annotationItems: [coordinate.pin],
                    annotationContent: {
                        MapAnnotation(coordinate: $0.coordinate.clLocationCoordinate2D) {
                            VStack(spacing: .zero) {
                                Circle()
                                    .foregroundStyle(.red)
                                    .frame(width: 20, height: 20)
                                    .shadow(radius: 8, x: 2, y: 2)
                                    .overlay {
                                        Circle()
                                            .foregroundStyle(.white)
                                            .frame(width: 4, height: 4)
                                            .offset(x: -4, y: -4)
                                    }
                                Rectangle()
                                    .foregroundStyle(.gray)
                                    .frame(width: 2, height: 16)
                                    .shadow(radius: 8, x: 2, y: 2)
                            }
                            .offset(y: -18)
                        }
                    }
                )
                .frame(height: 175)
                ZStack {
                    Color(uiColor: UIColor(red: 29 / 255, green: 29 / 255, blue: 29 / 255, alpha: 1.0))
                    HStack(spacing: 4) {
                        if let title = viewModel.locationInfo {
                            Text(title)
                        }
                        Spacer()
                        Text("위치 조절")
                            .foregroundStyle(.white)
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 8, height: 10)
                    }
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                }
                .frame(height: 25)
                .onTapGesture {
                    isPresenting = true
                }
            } else {
                Text("위치 정보 추가")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(height: 200)
                    .onTapGesture {
                        isPresenting = true
                    }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .sheet(isPresented: $isPresenting) {
            MapPicker()
        }
    }
}
