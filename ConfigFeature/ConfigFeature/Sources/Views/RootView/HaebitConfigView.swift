//
//  HaebitConfigView.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/23/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

public struct HaebitConfigView: View {
    public init() {}
    
    public var body: some View {
        NavigationStack {
            List {
                HaebitConfigHeaderSection()
                HaebitControlConfigSection()
                HaebitFeedbackConfigSection()
                HaebitAppearanceConfigSection()
                HaebitOtherConfigSection()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .ignoresSafeArea(.all)
            .scrollIndicators(.hidden)
            .headerProminence(.increased)
            .toolbar {
                ToolbarItem {
                    Button {
                        print("Close")
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                    }
                }
            }
        }
    }
}

#Preview {
    HaebitConfigView()
}
