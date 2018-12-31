//
//  RMPost.swift
//  Posts
//
//  Created by Samson Lopez on 30/12/2018.
//  Copyright © 2018 Samson Lopez. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

public protocol DomainObject {
    func repoObject<T>() -> T where T:Object
}

public protocol RepoObject {
    func domainObject<T>() -> T where T:DomainObject
}

public class RMPost: Object, RepoObject {
    @objc dynamic var id: Int = 0
    @objc dynamic var userId: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var body: String = ""
    
    public func domainObject<T>() -> T where T:DomainObject {
        return Post(id: id,
                    userId: userId,
                    title: title,
                    body: body) as! T
    }
}
