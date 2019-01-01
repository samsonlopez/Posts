//
//  PostDetailCoordinator.swift
//  Posts
//
//  Created by Samson Lopez on 01/01/2019.
//  Copyright © 2019 Samson Lopez. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


class PostDetailCoordinator: BaseCoordinator<PostViewData> {
    
    private let rootViewController: UIViewController
    private let postViewData:PostViewData
    private let postsRepository:PostsRepository

    init(rootViewController: UIViewController, postViewData: PostViewData, postsRepository: PostsRepository) {
        self.rootViewController = rootViewController
        self.postViewData = postViewData
        self.postsRepository = postsRepository
    }
    
     // Launch the  scene for Posts Detail
    override func start() -> Observable<PostViewData> {
        
        let viewController = PostDetailViewController.initFromStoryboard(name: "Main")

        let useCase = DefaultShowPostDetailUseCase(repository: postsRepository)
        let viewModel = PostDetailViewModel(useCase: useCase, postViewData: postViewData)
        viewController.viewModel = viewModel
        
        let navigationController = rootViewController.navigationController
        navigationController?.pushViewController(viewController, animated: true)

        return Observable.never()
    }
}
