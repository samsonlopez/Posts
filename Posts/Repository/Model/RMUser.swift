//
//  RMUser.swift
//  Posts
//
//  Created by Samson Lopez on 01/01/2019.
//  Copyright © 2019 Samson Lopez. All rights reserved.
//

import Foundation
import RealmSwift

// Realm repository object for User

public class RMUser: Object, RepoObject {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var username: String = ""
    
    public func domainObject<T>() -> T where T:DomainObject {
        return User(id: id,
                    name: name,
                    username: username) as! T
    }
}

extension User: DomainObject {
    public func repoObject<T>() -> T where T:Object {
        let rmUser = RMUser()
        rmUser.id = id
        rmUser.name = name
        rmUser.username = username
        
        return rmUser as! T
    }
}
