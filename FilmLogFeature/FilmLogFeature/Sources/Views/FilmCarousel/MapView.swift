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

struct MapView: View {
    @Binding var coordinate: Coordinate?
    
    var body: some View {
        VStack(spacing: .zero) {
            if let coordinate {
                Map(
                    coordinateRegion: .constant(
                        MKCoordinateRegion(
                            center: coordinate.clLocationCoordinate2D,
                            latitudinalMeters: 1_000,
                            longitudinalMeters: 1_000
                        )
                    )
                )
                .frame(height: 175)
                ZStack {
                    Color.secondary
                    NavigationLink {
                        Text("?")
                    } label: {
                        HStack {
                            Text("위치 조절")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                            Spacer()
                        }
                    }
                }
                .frame(height: 25)
            } else {
                NavigationLink {
                    Text("?")
                } label: {
                    Text("위치 정보 추가")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .frame(height: 200)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    VStack {
        MapView(coordinate: .constant(nil))
    }
    .padding(.horizontal, 12)
}
