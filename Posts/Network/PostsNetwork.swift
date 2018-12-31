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

public protocol PostsNetwork {
    func getPosts() -> Observable<[Post]>
}

// Default implementation of PostsNetwork, references any type of Network

public class DefaultPostsNetwork: PostsNetwork {
    
    let network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    // Retrieves all post entities from network endpoint
    public func getPosts() -> Observable<[Post]> {
        let url = URL(string: PostsURLSettings.posts)
        return network.getData(at: url!)
    }
    
}
