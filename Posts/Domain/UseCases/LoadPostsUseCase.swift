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
    
    var errorHandler: ErrorHandler? { get set }
    var isDataLoaded: Bool { get }
    
    // Retrieves all posts users and comments from the network and stores in repository
    func loadPosts() -> Observable<Bool>
}

// Concrete implementation of Load Posts use case, references PostsNetwork and PostsRepository

public class DefaultLoadPostsUseCase: LoadPostsUseCase {
    
    private let network: PostsNetwork
    private let repository: PostsRepository
    
    public var errorHandler: ErrorHandler?
    
    init(network: PostsNetwork, repository: PostsRepository) {
        self.network = network
        self.repository = repository
    }
    
    public var isDataLoaded: Bool {
        return repository.isDataLoaded
    }
   
    // Loads all posts, users and comments
    public func loadPosts() -> Observable<Bool> {
        return loadPosts(network: network, repository: repository)
            .flatMap { [weak self] success -> Observable<Bool> in
                guard let `self` = self else {
                    throw LoadPostsError.loadPostsFailed
                }
                return self.loadUsers(network: self.network, repository: self.repository)
            }
            .flatMap { [weak self] success -> Observable<Bool> in
                guard let `self` = self else {
                    throw LoadPostsError.loadUsersFailed
                }
                return self.loadComments(network: self.network, repository: self.repository)
            }
            .catchError { [weak errorHandler] error in
                if let errorHandler = errorHandler {
                    errorHandler.submit(error: error, type: .log)
                }
                throw error
            }
        
    }
    
    private func loadPosts(network: PostsNetwork, repository: PostsRepository) -> Observable<Bool> {
        return network.getPosts()
            .flatMap { posts in
                return repository.savePosts(posts: posts)
            }
    }
    
    private func loadUsers(network: PostsNetwork, repository: PostsRepository) -> Observable<Bool> {
        return network.getUsers()
            .flatMap { users in
                return repository.saveUsers(users: users)
        }
    }

    private func loadComments(network: PostsNetwork, repository: PostsRepository) -> Observable<Bool> {
        return network.getComments()
            .flatMap { comments in
                return repository.saveComments(comments: comments)
        }
    }

}

public enum LoadPostsError: String, Error {
    case loadPostsFailed = "Load posts failed"
    case loadUsersFailed = "Load users failed"
    case loadCommentsFailed = "Load comments failed"
}

