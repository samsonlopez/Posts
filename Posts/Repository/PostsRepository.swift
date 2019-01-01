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


public protocol PostsRepository: class {
    
    // Check if data is already loaded into repository
    var isDataLoaded: Bool { get }

    // Saves posts to repository
    func savePosts(posts: [Post]) -> Observable<Bool>

    // Saves users to repository
    func saveUsers(users: [User]) -> Observable<Bool>
    
    // Saves comments to repository
    func saveComments(comments: [Comment]) -> Observable<Bool>
    
    // Retrieves posts from repository
    func getPosts() -> Observable<[Post]>
    
    // Retrieves user from repository for specified userId
    func getUser(userId: Int) -> Observable<User>
    
    // Retrieves comments from repository for specified postId
    func getComments(postId: Int) -> Observable<[Comment]>
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

    public func saveUsers(users: [User]) -> Observable<Bool> {
        return repository.saveEntities(entities: users)
    }

    public func saveComments(comments: [Comment]) -> Observable<Bool> {
        return repository.saveEntities(entities: comments)
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
    
    public func getComments(postId: Int) -> Observable<[Comment]> {
        let realm = try! Realm()
        let comments = realm.objects(RMComment.self).filter(NSPredicate(format: "postId == %d", postId))

        return Observable.from(comments.toArray())
            .map {
                //print($0)
                return $0.domainObject()
            }.toArray()
    }
    
    public func getUser(userId: Int) -> Observable<User> {
        let realm = try! Realm()

        if let user = realm.objects(RMUser.self).filter(NSPredicate(format: "id == %d", userId)).first {
            return Observable.just(user.domainObject())
        } else {
            return Observable.error(PostsRepositoryError.userNotFound)
        }
    }
    
}

public enum PostsRepositoryError: String, Error {
    case userNotFound = "User not found"
}
