//
//  ShowPostDetailUseCase.swift
//  Posts
//
//  Created by Samson Lopez on 01/01/2019.
//  Copyright © 2019 Samson Lopez. All rights reserved.
//

import Foundation
import RxSwift

public protocol ShowPostDetailUseCase {
    
    // Retrieves a user from the repository based on userId
    func getUser(userId: Int) -> Observable<User>
    
    // Retrieves comments for a post from the repository based on postId
    func getComments(postId: Int) -> Observable<[Comment]>

}

class DefaultShowPostDetailUseCase: ShowPostDetailUseCase {
    
    private let repository: PostsRepository
    
    init(repository: PostsRepository) {
        self.repository = repository
    }
    
    func getUser(userId: Int) -> Observable<User> {
        return repository.getUser(userId: userId)
    }
    
    func getComments(postId: Int) -> Observable<[Comment]> {
        return repository.getComments(postId: postId)
    }
}
