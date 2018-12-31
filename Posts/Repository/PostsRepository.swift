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
    func savePosts(posts: [Post]) -> Observable<Bool>
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
    
}
