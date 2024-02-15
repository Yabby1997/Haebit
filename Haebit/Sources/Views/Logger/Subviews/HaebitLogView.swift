//
//  HaebitLogView.swift
//  HaebitDev
//
//  Created by Seunghun on 2/11/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitLogger

struct HaebitLogView: View {
    let log: HaebitLog
    var body: some View {
        ScrollView {
            LivePhotoView(livePhoto: log.image.livePhoto)
            Text(log.date.description)
            Text("\(log.iso)")
            Text("\(log.shutterSpeed)")
            Text("\(log.aperture)")
            Text("\(log.memo)")
            Text("\(log.coordinate?.latitude ?? .zero)")
            Text("\(log.coordinate?.longitude ?? .zero)")
        }
    }
}

//#Preview {
//    HaebitLogView(log: HaebitLog)
//}

extension HaebitLivePhoto {
    var livePhoto: LivePhoto {
        if let videoPath {
            return .init(
                image: URL.homeDirectory.appending(path: imagePath),
                video: URL.homeDirectory.appending(path: videoPath)
            )
        } else {
            return .init(
                image: URL.homeDirectory.appending(path: imagePath),
                video: nil
            )
        }
    }
}
