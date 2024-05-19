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
    @Published var latitude: Float?
    @Published var longitude: Float?
    @Published var focalLength: UInt16?
    @Published var iso: UInt16?
    @Published var shutterSpeed: Float?
    @Published var aperture: Float?
    @Published var memo: String = ""
    @Published var isLoading = false
    
    var isRegisterable: Bool {
        imageData != nil && focalLength != nil && iso != nil && shutterSpeed != nil && aperture != nil
    }
    
    init(logger: HaebitLogger) {
        self.logger = logger
        try? createDirectoryIfNeeded(for: imageDirectory.path)
    }
    
    func register() {
        guard let imageData, let focalLength, let iso, let shutterSpeed, let aperture else { return }
        isLoading = true
        let outputFileURL = imageDirectory.appending(path: UUID().uuidString + ".jpeg")
        
        var coordinate: HaebitCoordinate?
        if let latitude, let longitude {
            coordinate = HaebitCoordinate(latitude: Double(latitude), longitude: Double(longitude))
        }
        
        Task {
            do {
                try imageData.write(to: outputFileURL, options: [.atomic, .completeFileProtection])
                try await logger.save(
                    log: HaebitLog(
                        date: date,
                        coordinate: coordinate,
                        image: outputFileURL.relativePath,
                        focalLength: focalLength,
                        iso: iso,
                        shutterSpeed: shutterSpeed,
                        aperture: aperture,
                        memo: memo
                    )
                )
                isLoading = false
                clear()
            } catch {
                isLoading = false
                print("Error Occurred!: \(error.localizedDescription)")
            }
        }
    }
    
    private func clear() {
        imageData = nil
        date = .now
        latitude = nil
        longitude = nil
        focalLength = nil
        iso = nil
        shutterSpeed = nil
        aperture = nil
        memo = ""
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
