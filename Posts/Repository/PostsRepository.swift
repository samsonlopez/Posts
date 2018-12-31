//
//  PostsRepository.swift
//  Posts
//
//  Created by Samson Lopez on 30/12/2018.
//  Copyright © 2018 Samson Lopez. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift


public protocol PostsRepository {
    
    // Check if data is already loaded into repository
    var isDataLoaded: Bool { get }

    // Saves posts to repository
    func savePosts(posts: [Post]) -> Observable<Bool>

    // Retrieves posts from repository
    func getPosts() -> Observable<[Post]>
}

// Default implementation of PostsRepository, references any type of Repository

public class DefaultPostsRepository: PostsRepository {
    
    let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }

    public func savePosts(posts: [Post]) -> Observable<Bool> {
        return repository.saveEntities(entities: posts)
    }
    
    public var isDataLoaded: Bool {
        return repository.isDataLoaded
    }
    
    public func getPosts() -> Observable<[Post]> {
        return repository.getData(type: RMPost.self)
            .map {
                return $0.map {
                    let post = $0
                    return post.domainObject()
                }
            }
    }

}

extension Post: DomainObject {
    
    public func repoObject<T>() -> T where T:Object {
        let rmPost = RMPost()
        rmPost.id = id
        rmPost.userId = userId
        rmPost.title = title
        rmPost.body = body
        
        return rmPost as! T
    }
    
    func asPostViewData() -> PostViewData {
        return PostViewData(id: id,
                            userId: userId,
                            title: title,
                            body: body)
    }
}
