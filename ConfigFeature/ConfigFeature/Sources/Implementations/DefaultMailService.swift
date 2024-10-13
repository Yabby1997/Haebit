//
//  DefaultMailService.swift
//  ConfigFeature
//
//  Created by Seunghun on 10/13/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import UIKit

@MainActor
public final class DefaultMailService: MailService {
    public init() {}
    
    public func sendMail(to recipient: String, subject: String, body: String) {
        var urlComponent = URLComponents(string: recipient)
        urlComponent?.scheme = "mailto"
        urlComponent?.queryItems = [
            .init(name: "subject", value: subject),
            .init(name: "body", value: body),
        ]
        guard let url = urlComponent?.url else { return }
        UIApplication.shared.open(url)
    }
}
