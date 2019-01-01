//
//  PostsListViewController.swift
//  Posts
//
//  Created by Samson Lopez on 31/12/2018.
//  Copyright © 2018 Samson Lopez. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
//import RxRealm

class PostsViewController: UITableViewController, StoryboardInitializable {
    
    var viewModel: PostsListViewModel!
    var postsLoader: PostsLoader!
    var errorHandler: ErrorHandler!

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve and load posts data to repository if it is not already loaded.
        if(!postsLoader.isDataLoaded) {
            postsLoader.loadPosts()
                .subscribe(onNext: { success in
                    DispatchQueue.main.async {
                        self.bindUI()
                    }
                }, onError: { [weak errorHandler] (error) in
                    errorHandler?.submit(error: error, type: .alert)
                })
                .disposed(by: disposeBag)
            
        } else {
            self.bindUI()
        }
    }
    
    // Bind UI elements/actions (tableview, cell selection) to corresponding observables in viewModel.
    func bindUI() {
        viewModel.posts
            .drive(tableView.rx.items(cellIdentifier: "PostsCell")) { _, post, cell in
                cell.textLabel?.text = post.title
                cell.detailTextLabel?.text = post.body
            }
            .disposed(by: disposeBag)
        
        self.tableView.rx
            .modelSelected(PostViewData.self)
            .bind(to: viewModel.selectPost)
            .disposed(by: disposeBag)
    }
        
}
