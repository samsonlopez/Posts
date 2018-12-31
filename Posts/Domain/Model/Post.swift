//
//  Post.swift
//  Posts
//
//  Created by Samson Lopez on 30/12/2018.
//  Copyright © 2018 Samson Lopez. All rights reserved.
//

import Foundation

// Post domain model which maps with JSON from posts network endpoint
public struct Post: Codable {
    
    let id: Int
    let userId: Int
    let title: String
    let body: String
    
    public init(id: Int,
                userId: Int,
                title: String,
                body: String) {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
    }
    
}
