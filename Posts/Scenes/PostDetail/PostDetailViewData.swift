//
//  PostDetailViewData.swift
//  Posts
//
//  Created by Samson Lopez on 01/01/2019.
//  Copyright © 2019 Samson Lopez. All rights reserved.
//

import Foundation

// View data used as DTO between vieController and viewModel

public struct PostDetailViewData {
    let author: String
    let title: String
    let description: String
    let commentCount: Int
}
