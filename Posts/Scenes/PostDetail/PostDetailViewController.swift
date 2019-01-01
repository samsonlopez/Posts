//
//  PostDetailViewController.swift
//  Posts
//
//  Created by Samson Lopez on 01/01/2019.
//  Copyright © 2019 Samson Lopez. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa
import RxRealm

class PostDetailViewController: UITableViewController, StoryboardInitializable {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var titleTableViewCell: UITableViewCell!
    @IBOutlet weak var descriptionTableViewCell: UITableViewCell!
    @IBOutlet weak var commentCountTableViewCell: UITableViewCell!
    
    var viewModel: PostDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.author.asObservable()
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel?.title.asObservable()
            .bind(to: titleTableViewCell.textLabel!.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.description.asObservable()
            .bind(to: descriptionTableViewCell.textLabel!.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.commentCount.asObservable()
            .map { return "\($0) comments"}
            .bind(to: commentCountTableViewCell.detailTextLabel!.rx.text)
            .disposed(by: disposeBag)
    }
    
}
