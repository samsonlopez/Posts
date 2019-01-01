//
//  PostViewData.swift
//  Posts
//
//  Created by Samson Lopez on 31/12/2018.
//  Copyright © 2018 Samson Lopez. All rights reserved.
//

import Foundation

// View data used as DTO between vieController and viewModel

public struct PostViewData {
    public let id: Int
    public let userId: Int
    public let title: String
    public let body: String
}
