//
//  MockHaebitLogRepository.swift
//  HaebitDev
//
//  Created by Seunghun on 2/6/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation
import HaebitLogger

class MockHaebitLogRepository: HaebitLogRepository {
    let sanFrancisco = HaebitCoordinate(latitude: 37.7749, longitude: -122.4194)
    let sanFrancisco1 = HaebitCoordinate(latitude: 37.775051043038545, longitude: -122.41237811867396)
    let losAngeles = HaebitCoordinate(latitude: 34.0522, longitude: -118.2437)
    let losAngeles1 = HaebitCoordinate(latitude: 34.05298616055887, longitude: -118.24058668970835)
    let losAngeles2 = HaebitCoordinate(latitude: 34.052263606700585, longitude: -118.24858092220602)
    let losAngeles3 = HaebitCoordinate(latitude: 34.048108802507194, longitude: -118.24901697125135)
    
    var testData: [HaebitLog] {
        [
            HaebitLog(
                id: UUID(),
                date: Date(timeIntervalSince1970: 1706972400),
                coordinate: sanFrancisco,
                image: "",
                focalLength: 50,
                iso: 100,
                shutterSpeed: 30,
                aperture: 2,
                memo: "Spongebob"
            ),
            HaebitLog(
                id: UUID(),
                date: Date(timeIntervalSince1970: 1706764329),
                coordinate: sanFrancisco1,
                image: "",
                focalLength: 50,
                iso: 100,
                shutterSpeed: 60,
                aperture: 1.4,
                memo: "Patrick"
            ),
            HaebitLog(
                id: UUID(),
                date: Date(timeIntervalSince1970: 1707220190),
                coordinate: losAngeles,
                image: "",
                focalLength: 50,
                iso: 400,
                shutterSpeed: 15,
                aperture: 11,
                memo: "Squidward"
            ),
            HaebitLog(
                id: UUID(),
                date: Date(timeIntervalSince1970: 1707210190),
                coordinate: losAngeles1,
                image: "",
                focalLength: 50,
                iso: 800,
                shutterSpeed: 30,
                aperture: 16,
                memo: "Spongebob square pants"
            ),
            HaebitLog(
                id: UUID(),
                date: Date(timeIntervalSince1970: 1707112990),
                coordinate: losAngeles2,
                image: "",
                focalLength: 50,
                iso: 800,
                shutterSpeed: 60,
                aperture: 2,
                memo: "Spongebob and Patrick"
            ),
            HaebitLog(
                id: UUID(),
                date: Date(timeIntervalSince1970: 1707210210),
                coordinate: losAngeles3,
                image: "",
                focalLength: 50,
                iso: 800,
                shutterSpeed: 8,
                aperture: 22,
                memo: "Squid"
            ),
        ]
    }
    
    var data: [HaebitLog] = []
    
    init() {
        self.data = testData
    }
    
    func logs() async throws -> [HaebitLog] {
        data
    }
    
    func save(log: HaebitLog) async throws {
        data.append(log)
    }
    
    func remove(log id: UUID) async throws {
        data.removeAll { $0.id == id }
    }
}
