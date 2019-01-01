//
//  PostsListCoordinator.swift
//  Posts
//
//  Created by Samson Lopez on 31/12/2018.
//  Copyright © 2018 Samson Lopez. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RealmSwift

class PostsCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    
    var rootViewController:UIViewController?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // Launch the initial scene for Posts List
    override func start() -> Observable<Void> {
        
        // Create posts repository with concrete Realm repository
        let postsRepository = DefaultPostsRepository(repository: RealmRepository())
        
        // Create posts use case and view model with reference to posts use case
        let postsUseCase = DefaultListPostsUseCase(repository: postsRepository)
        let viewModel = PostsListViewModel(useCase: postsUseCase)

        // Create posts network with concrete REST network
        let network = RESTNetwork(urlSession: URLSession.shared)
        let postsNetwork = DefaultPostsNetwork(network: network)
        
        // Create posts loader service
        let loadPostsUseCase = DefaultLoadPostsUseCase(network: postsNetwork, repository: postsRepository)
        loadPostsUseCase.errorHandler = DefaultErrorHandler.shared
        let postsLoader = DefaultPostsLoader(useCase: loadPostsUseCase)

        let viewController = PostsViewController.initFromStoryboard(name: "Main")
        rootViewController = viewController
        let navigationController = UINavigationController(rootViewController: viewController)
        
        viewController.viewModel = viewModel
        viewController.postsLoader = postsLoader
        viewController.errorHandler = DefaultErrorHandler.shared

        // Set posts list as root
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return Observable.never()
    }
    
}
