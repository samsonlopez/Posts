//
//  RMComment.swift
//  Posts
//
//  Created by Samson Lopez on 01/01/2019.
//  Copyright © 2019 Samson Lopez. All rights reserved.
//

import Foundation
import RealmSwift

// Realm repository object for Comment

public class RMComment: Object, RepoObject {
    @objc dynamic var postId: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var body: String = ""
    
    public func domainObject<T>() -> T where T:DomainObject {
        return Comment(postId: postId,
                       id: id,
                       name: name,
                       email: email,
                       body: body) as! T
    }
}

extension Comment: DomainObject {
    public func repoObject<T>() -> T where T:Object {
        let rmComment = RMComment()
        rmComment.postId = postId
        rmComment.id = id
        rmComment.name = name
        rmComment.email = email
        rmComment.body = body
        
        return rmComment as! T
    }
}
