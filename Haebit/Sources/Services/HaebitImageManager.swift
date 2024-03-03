//
//  HaebitImageManager.swift
//  HaebitDev
//
//  Created by Seunghun on 3/3/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Photos
import UIKit

/// Image that managed by `Haebit`.
struct HaebitImage {
    /// Identifier of full quality image that saved in Photo Library.
    let assetIdentifier: String
    /// Relative path to low quality thumbnail image file from Home directory.s
    let thumbnailPath: String
}

/// A class that manages image in `Haebit`.
final class HaebitImageManager {
    /// Errors that can occur while using ``HaebitImageManager``
    enum Errors: Error {
        /// Indicates that Photo Library access is not authorized.
        case notAuthorized
        /// Indicates that provided url is not valid image data.
        case failedToLoad
    }
    
    private let fileManager = FileManager.default
    private let thumbnailDirectory = URL.homeDirectory.appending(path: "Documents/Haebit/Thumbnails")
    
    /// Sets up the ``HaebitImageManager``.
    ///
    /// Call this method prior to call ``save(image:date:coordinate:)``. If this method fails, it may not work properly.
    func setup() async throws {
        try createDirectoryIfNeeded(for: thumbnailDirectory.path)
        return try await withCheckedThrowingContinuation { continuation in
            PHPhotoLibrary.requestAuthorization { status in
                guard status == .authorized else {
                    continuation.resume(throwing: Errors.notAuthorized)
                    return
                }
            }
        }
    }
    
    private func createDirectoryIfNeeded(for path: String) throws {
        if fileManager.fileExists(atPath: path) {
            print("Directory Exists: \(path)")
            return
        }
        try fileManager.createDirectory(
            atPath: path,
            withIntermediateDirectories: true,
            attributes: nil
        )
        print("Directory Created: \(path)")
    }
    
    /// Saves an image in a suitable format for `Haebit`.
    ///
    /// - Parameters:
    ///   - url: The temporary URL of the image to save.
    ///   - date: The creation date to be assigned to the image. Default value is current date and time.
    ///   - coordinate: The coordinate information associated with the image. Default value is `nil`.
    ///
    /// - Returns: A ``HaebitImage`` object containing the photo asset identifier and thumbnail path.
    func save(
        image url: URL,
        date: Date = Date(),
        coordinate: Coordinate? = nil
    ) async throws -> HaebitImage {
        let thumbnailURL = thumbnailDirectory.appending(path: UUID().uuidString + ".jpeg")
        let tempImageData = try Data(contentsOf: url)
        try compressAndWrite(image: tempImageData, with: 0.5, to: thumbnailURL)
        let photoAssetIdentifier = try await saveToPhotoLibrary(imageData: tempImageData, date: date, coordinate: coordinate)
        try? fileManager.removeItem(at: url)
        return HaebitImage(assetIdentifier: photoAssetIdentifier, thumbnailPath: thumbnailURL.relativePath)
    }
    
    private func compressAndWrite(image data: Data, with quality: CGFloat, to url: URL) throws {
        guard let compressed = UIImage(data: data)?.jpegData(compressionQuality: quality) else {
            throw Errors.failedToLoad
        }
        try compressed.write(to: url, options: [.atomic, .completeFileProtection])
    }
    
    private func saveToPhotoLibrary(imageData: Data, date: Date, coordinate: Coordinate?) async throws -> String {
        var identifier: String?
        return try await withCheckedThrowingContinuation { continuation in
            PHPhotoLibrary.shared().performChanges {
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: imageData, options: nil)
                creationRequest.creationDate = Date()
                if let coordinate {
                    creationRequest.location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                }
                if let assetPlaceholder = creationRequest.placeholderForCreatedAsset {
                    identifier = assetPlaceholder.localIdentifier
                }
            } completionHandler: { isSuccess, error in
                if let error {
                    continuation.resume(throwing: error)
                }
                guard isSuccess, let identifier else {
                    continuation.resume(throwing: NSError(domain: "", code: 0))
                    return
                }
                continuation.resume(returning: identifier)
            }
        }
    }
}
