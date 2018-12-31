//
//  PostsLoader.swift
//  Posts
//
//  Created by Samson Lopez on 31/12/2018.
//  Copyright © 2018 Samson Lopez. All rights reserved.
//

import Foundation
import RxSwift

public protocol PostsLoader {
    var isDataLoaded: Bool { get }
    func loadPosts() -> Observable<Bool>
}

// Posts loader service to retrieve and load posts into repository

public class DefaultPostsLoader: PostsLoader {
    
    private let useCase: LoadPostsUseCase
    
    init(useCase: LoadPostsUseCase) {
        self.useCase = useCase
    }
    
    public var isDataLoaded: Bool {
        return useCase.isDataLoaded
    }
    
    public func loadPosts() -> Observable<Bool> {
        return useCase.loadPosts()
    }
    
}
