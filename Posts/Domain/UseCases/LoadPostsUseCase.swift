//
//  LoadPostsUseCase.swift
//  Posts
//
//  Created by Samson Lopez on 30/12/2018.
//  Copyright © 2018 Samson Lopez. All rights reserved.
//

import Foundation
import RxSwift

public protocol LoadPostsUseCase {
    
    // Retrieves all posts from the network and stores in repository
    func loadPosts() -> Observable<Bool>
}

// Concrete implementation of Load Posts use case, references PostsNetwork and PostsRepository

public class DefaultLoadPostsUseCase: LoadPostsUseCase {
    
    private let network: PostsNetwork
    private let repository: PostsRepository
    
    init(network: PostsNetwork, repository: PostsRepository) {
        self.network = network
        self.repository = repository
    }
    
    public func loadPosts() -> Observable<Bool> {
        return loadPosts(network: network, repository: repository)
    }
    
    private func loadPosts(network: PostsNetwork, repository: PostsRepository) -> Observable<Bool> {
        return network.getPosts().flatMap { posts in
            return repository.savePosts(posts: posts)
        }
    }
    
}
