//
//  AppCoordinator.swift
//  Posts
//
//  Created by Samson Lopez on 31/12/2018.
//  Copyright © 2018 Samson Lopez. All rights reserved.
//

import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // Coordinate to launch the initial scene for Posts
    override func start() -> Observable<Void> {
        let postsCoordinator = PostsCoordinator(window: window)
        return coordinate(to: postsCoordinator)
    }
    
}
