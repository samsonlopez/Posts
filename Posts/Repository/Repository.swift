//
//  Repository.swift
//  Posts
//
//  Created by Samson Lopez on 30/12/2018.
//  Copyright © 2018 Samson Lopez. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

public protocol Repository {

    // Check if data is already loaded into repository
    var isDataLoaded: Bool { get }
    
    // Saves entity array (Posts, User, Comment) to repository
    func saveEntities<T>(entities: [T]) -> Observable<Bool> where T:DomainObject
    
    // Retrieves array of objects for specified entity from repository
    func getData<T: Object>(type: T.Type) -> Observable<[T]>
}

// Concrete implementation of Repository with Realm

public class RealmRepository: Repository {
    
    public var isDataLoaded: Bool {
        let realm = try! Realm()
        let posts = realm.objects(RMPost.self)
        if posts.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    public func saveEntities<T>(entities: [T]) -> Observable<Bool> where T:DomainObject {
        let realm = try! Realm()
        return Observable.from(entities)
            .map {
                let entity = $0
                
                do {
                    try realm.write {
                        realm.add(entity.repoObject())
                    }
                } catch {
                    throw error
                }
                return true
            }.reduce(true) { $0 || $1}
    }

    public func getData<T: Object>(type: T.Type) -> Observable<[T]> {
        let realm = try! Realm()
        let posts = realm.objects(T.self)
        
        return Observable.from(optional: posts.toArray())
    }
    
}

enum RepositoryError: String, Error {
    case notAccessible = "Repository not accessible"
}
