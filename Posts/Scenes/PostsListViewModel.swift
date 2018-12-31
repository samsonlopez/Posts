//
//  PostsListViewModel.swift
//  Posts
//
//  Created by Samson Lopez on 31/12/2018.
//  Copyright © 2018 Samson Lopez. All rights reserved.
//

import Foundation

import RealmSwift
import RxSwift
import RxCocoa
import RxRealm

class PostsListViewModel {
    
    private let useCase: ListPostsUseCase
    
    // PostDetail: Trigger from view controller
    let selectPost: AnyObserver<PostViewData>
    
    // PostDetail: Observable to coordinator
    let showPostDetail: Observable<PostViewData>
    
    let disposeBag = DisposeBag()

    init(useCase: ListPostsUseCase) {
        self.useCase = useCase
        
        let _selectPost = PublishSubject<PostViewData>()
        self.selectPost = _selectPost.asObserver()
        self.showPostDetail = _selectPost.asObservable()
    }

    // Retrieves posts which are to be displaed in list
    lazy var posts: Driver<[PostViewData]> = {
        return getPostsViewData()
            .asDriver(onErrorJustReturn: [])
    }()

    func getPosts() -> Observable<[Post]> {
        return useCase.getPosts()
    }

    // Maps Post to PostViewData and returns array
    private func getPostsViewData() -> Observable<[PostViewData]> {
        return getPosts().map {
            return $0.map {
                return $0.asPostViewData()
            }
        }
    }    
    
}
