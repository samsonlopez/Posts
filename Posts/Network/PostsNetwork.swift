//
//  PostsNetwork.swift
//  Posts
//
//  Created by Samson Lopez on 30/12/2018.
//  Copyright © 2018 Samson Lopez. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public protocol PostsNetwork: class {

    // Retrieves all post entities from network endpoint
    func getPosts() -> Observable<[Post]>

    // Retrieves all user entities from network endpoint
    func getUsers() -> Observable<[User]>
    
    // Retrieves all comment entities from network endpoint
    func getComments() -> Observable<[Comment]>
}

// Default implementation of PostsNetwork, references any type of Network

public class DefaultPostsNetwork: PostsNetwork {
    
    let network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    public func getPosts() -> Observable<[Post]> {
        let url = URL(string: PostsURLSettings.posts)
        return network.getData(at: url!)
    }

    public func getUsers() -> Observable<[User]> {
        let url = URL(string: PostsURLSettings.users)
        return network.getData(at: url!)
    }
    
    public func getComments() -> Observable<[Comment]> {
        let url = URL(string: PostsURLSettings.comments)
        return network.getData(at: url!)
    }
}
