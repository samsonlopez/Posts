//
//  ListPostsUseCase.swift
//  Posts
//
//  Created by Samson Lopez on 31/12/2018.
//  Copyright © 2018 Samson Lopez. All rights reserved.
//

import Foundation
import RxSwift

public protocol ListPostsUseCase {
    
    // Retrieves all posts from the network and stores in repository
    func getPosts() -> Observable<[Post]>
}

class DefaultListPostsUseCase: ListPostsUseCase {
    
    private let repository: PostsRepository
    
    init(repository: PostsRepository) {
        self.repository = repository
    }
    
    func getPosts() -> Observable<[Post]> {
        return repository.getPosts()
            .map {
                // Demo - Business logic in use case.
                // Capitalize first letter of string.
                return $0.map {
                    let title = $0.title.capitalizingFirstLetter()
                    let post = Post(id: $0.id, userId: $0.userId, title: title, body: $0.body)
                    return post
                }
            }
    }
    
}

// Helper extension, can be kept along with common methods, retained here to show with Demo of business logic.
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

