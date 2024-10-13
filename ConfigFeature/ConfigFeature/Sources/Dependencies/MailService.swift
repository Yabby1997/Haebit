//
//  MailService.swift
//  ConfigFeature
//
//  Created by Seunghun on 10/13/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation

public protocol MailService {
    @MainActor
    func sendMail(to recipient: String, subject: String, body: String)
}
