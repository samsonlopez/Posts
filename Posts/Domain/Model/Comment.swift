//
//  Comment.swift
//  Posts
//
//  Created by Samson Lopez on 01/01/2019.
//  Copyright © 2019 Samson Lopez. All rights reserved.
//

import Foundation

// Comment domain model which maps with JSON from comments network endpoint

public struct Comment: Codable {
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
    
    public init(postId: Int,
                id: Int,
                name: String,
                email: String,
                body: String) {
        self.postId = postId
        self.id = id
        self.name = name
        self.email = email
        self.body = body
    }
}
