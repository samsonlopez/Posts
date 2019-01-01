//
//  PostDetailViewModel.swift
//  Posts
//
//  Created by Samson Lopez on 01/01/2019.
//  Copyright © 2019 Samson Lopez. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa
import RxRealm

class PostDetailViewModel {
    
    private let useCase: ShowPostDetailUseCase
    
    let disposeBag = DisposeBag()
    
    let author = Variable("")
    let title = Variable("")
    let description = Variable("")
    let commentCount = Variable(0)
    
    func getPostDetailViewData(postViewData: PostViewData) -> PostDetailViewData {
        
        var _author: String = ""

        useCase.getUser(userId: postViewData.userId)
            .subscribe(onNext: { user in
                _author = user.name
            }, onError: { (error) in
                print(error)
            }).disposed(by: disposeBag)

        
        var _commentCount: Int = 0
        useCase.getComments(postId: postViewData.id)
            .subscribe(onNext: { comments in
                _commentCount = comments.count
            }, onError: { (error) in
                print(error)
            }).disposed(by: disposeBag)
        
        return PostDetailViewData(author: _author,
                                  title: postViewData.title,
                                  description: postViewData.body,
                                  commentCount: _commentCount)
    }
    
    init(useCase: ShowPostDetailUseCase, postViewData: PostViewData) {
        self.useCase = useCase
        
        let viewData = getPostDetailViewData(postViewData: postViewData)
        self.author.value = viewData.author
        self.title.value = viewData.title
        self.description.value = viewData.description
        self.commentCount.value = viewData.commentCount
    }
    
}
