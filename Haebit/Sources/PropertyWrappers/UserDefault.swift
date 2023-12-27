//
//  UserDefault.swift
//  Haebit
//
//  Created by Seunghun on 12/27/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefault<T> where T: Codable {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get { (try? JSONDecoder().decode(T.self, from: UserDefaults.standard.data(forKey: key) ?? Data())) ?? defaultValue }
        set { UserDefaults.standard.set(try? JSONEncoder().encode(newValue), forKey: key) }
    }
}
