//
//  FilmAnnotation.swift
//  HaebitDev
//
//  Created by Seunghun on 4/16/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import MapKit

class FilmAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let film: Film
    
    init?(film: Film) {
        guard let coordinate = film.coordinate?.clLocationCoordinate2D else { return nil }
        self.coordinate = coordinate
        self.film = film
    }
}

extension Coordinate {
    var clLocationCoordinate2D: CLLocationCoordinate2D {
        .init(latitude: self.latitude, longitude: self.longitude)
    }
}
