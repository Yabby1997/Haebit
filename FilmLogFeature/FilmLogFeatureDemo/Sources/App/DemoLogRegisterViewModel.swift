//
//  DemoLogRegisterViewModel.swift
//
//
//  Created by Seunghun on 5/12/24.
//

import Foundation
import HaebitLogger

@MainActor
class DemoLogRegisterViewModel: ObservableObject {
    private let logger: HaebitLogger
    
    private let imageDirectory = URL.homeDirectory.appending(path: "Documents/FilmLogFeatureDemo/Images")
    @Published var imageData: Data?
    @Published var date: Date = .now
    @Published var latitude: Double = .zero
    @Published var longitude: Double = .zero
    @Published var focalLength: UInt16 = 50
    @Published var iso: UInt16 = 400
    @Published var shutterSpeed: Float = 2000
    @Published var aperture: Float = 1.4
    @Published var memo: String = ""
    @Published var isLoading = false
    
    init(logger: HaebitLogger) {
        self.logger = logger
        try? createDirectoryIfNeeded(for: imageDirectory.path)
    }
    
    func register() {
        guard let imageData else { return }
        isLoading = true
        let outputFileURL = imageDirectory.appending(path: UUID().uuidString + ".jpeg")
        Task {
            do {
                try imageData.write(to: outputFileURL, options: [.atomic, .completeFileProtection])
                try await logger.save(
                    log: HaebitLog(
                        date: date,
                        coordinate: HaebitCoordinate(latitude: latitude, longitude: longitude),
                        image: outputFileURL.relativePath,
                        focalLength: focalLength,
                        iso: iso,
                        shutterSpeed: shutterSpeed,
                        aperture: aperture,
                        memo: memo
                    )
                )
                isLoading = false
                print("Register Success!")
            } catch {
                isLoading = false
                print("Error Occurred!: \(error.localizedDescription)")
            }
        }
    }
    
    private func createDirectoryIfNeeded(for path: String) throws {
        if FileManager.default.fileExists(atPath: path) {
            print("Directory Exists: \(path)")
            return
        }
        try FileManager.default.createDirectory(
            atPath: path,
            withIntermediateDirectories: true,
            attributes: nil
        )
        print("Directory Created: \(path)")
    }
}

extension URL {
    var relativePath: String {
        guard path.hasPrefix(URL.homeDirectory.path) else { return path }
        return String(path.dropFirst(URL.homeDirectory.path.count))
    }
}
