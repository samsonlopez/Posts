//
//  ListPostsUseCase.swift
//  Posts
//
//  Created by Samson Lopez on 31/12/2018.
//  Copyright © 2018 Samson Lopez. All rights reserved.
//

import Foundation
import RxSwift

public protocol ListPostsUseCase {
    
    // Retrieves all posts from the network and stores in repository
    func getPosts() -> Observable<[Post]>
}

class DefaultListPostsUseCase: ListPostsUseCase {
    
    private let repository: PostsRepository
    
    init(repository: PostsRepository) {
        self.repository = repository
    }
    
    func getPosts() -> Observable<[Post]> {
        return repository.getPosts()
    }
    
}

