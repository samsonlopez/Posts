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


class PostsViewController: UITableViewController, StoryboardInitializable {
    
    var viewModel: PostsListViewModel!
    var postsLoader: PostsLoader!
    var errorHandler: ErrorHandler!

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve and load posts data to repository if it is not already loaded.
        if(!postsLoader.isDataLoaded) {
            loadPostsData()
        } else {
            self.bindUI()
        }
        
        // Retry to load posts on re-launch from background if it not already loaded.
        NotificationCenter.default.addObserver(self, selector: #selector(applicationRelaunched(_:)),
                                               name: Notification.Name.applicationReLaunched, object: nil)
    }
    
    @objc func applicationRelaunched(_ notification:Notification) {
        if(!postsLoader.isDataLoaded) {
            loadPostsData()
        }
    }
    
    private func loadPostsData() {
        postsLoader.loadPosts()
            .subscribe(onNext: { success in
                DispatchQueue.main.async {
                    self.bindUI()
                }
            }, onError: { [weak errorHandler] (error) in
                errorHandler?.submit(error: error, type: .alert)
            })
            .disposed(by: disposeBag)
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
