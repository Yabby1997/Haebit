//
//  HaebitLoggerViewModel.swift
//  HaebitDev
//
//  Created by Seunghun on 2/6/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation
import HaebitLogger

final class HaebitLoggerViewModel: ObservableObject {
    private let logger: HaebitLogger
    @Published var logs: [HaebitLog] = []
    
    init(logger: HaebitLogger) {
        self.logger = logger
    }
    
    func onAppear() {
        Task { @MainActor in
            logs = (try? await logger.logs()) ?? []
        }
    }
}
