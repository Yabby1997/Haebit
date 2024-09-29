//
//  MockAppStoreOpener.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/29/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import ConfigFeature
import Foundation

struct MockAppStoreOpener: AppStoreOpener {
    func openWriteReview() {
        print("Write Review")
    }
    
    func openAppPage() {
        print("App Page")
    }
}
