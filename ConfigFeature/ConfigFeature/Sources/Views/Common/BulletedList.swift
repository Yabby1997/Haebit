//
//  BulletedList.swift
//  ConfigFeature
//
//  Created by Seunghun on 10/7/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct BulletedList: View {
    private let listItems: [BulletedListItem]
    
    init(listItems: [LocalizedStringResource]) {
        self.listItems = listItems.map { BulletedListItem(resource: $0) }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(listItems) { item in
                BulletedText(item.resource)
            }
        }
        .padding(.horizontal, 8)
    }
}

fileprivate struct BulletedListItem: Identifiable {
    let id = UUID()
    let resource: LocalizedStringResource
}
