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

    func saveEntities<T>(entities: [T]) -> Observable<Bool> where T:DomainObject
}

// Concrete implementation of Repository with Realm

public class RealmRepository: Repository {
    
    let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    public func saveEntities<T>(entities: [T]) -> Observable<Bool> where T:DomainObject {
        //let realm = try! Realm()
        return Observable.from(entities)
            .map { [weak realm] in
                print($0)
                let entity = $0
                
                do {
                    guard let realm = realm else {
                        return false
                    }
                    try realm.write {
                        realm.add(entity.repoObject())
                    }
                } catch {
                    throw error
                }
                return true
            }.reduce(true) { $0 || $1}
    }
    
}

enum RepositoryError: String, Error {
    case notAccessible = "Repository not accessible"
}
