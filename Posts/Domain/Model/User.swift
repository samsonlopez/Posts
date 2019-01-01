//
//  User.swift
//  Posts
//
//  Created by Samson Lopez on 01/01/2019.
//  Copyright © 2019 Samson Lopez. All rights reserved.
//

import Foundation

// User domain model which maps with JSON from users network endpoint

public struct User: Codable {
    let id: Int
    let name: String
    let username: String
    
    // More properties from network end point, but trimmed for brevity.
    
    public init(id: Int,
                name: String,
                username: String) {
        self.id = id
        self.name = name
        self.username = username
    }
}
