//
//  ShowPostDetailsUseCaseTests.swift
//  PostsTests
//
//  Created by Samson Lopez on 01/01/2019.
//  Copyright © 2019 Samson Lopez. All rights reserved.
//

import XCTest
import RxSwift
import RealmSwift
import RxBlocking
@testable import Posts

class ShowPostDetailUseCaseTests: XCTestCase {
    
    var sut_showPostDetailUseCase: ShowPostDetailUseCase!
    var loadPostsUseCase: LoadPostsUseCase!
    var mockNetwork: MockNetwork! // Also holds mock var entityCount on return
    var realm: Realm!
    
    override func setUp() {
        
        // Mock network to load test data from file
        mockNetwork = MockNetwork()
        let postsNetwork = DefaultPostsNetwork(network: mockNetwork)
        
        // In-memory Realm for testing, loads clear each time
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "Posts-tests"
        realm = try! Realm()
        
        let repository = RealmRepository()
        let postsRepository = DefaultPostsRepository(repository: repository)
        loadPostsUseCase = DefaultLoadPostsUseCase(network: postsNetwork, repository: postsRepository)
        
        sut_showPostDetailUseCase = DefaultShowPostDetailUseCase(repository: postsRepository)
    }
    
    override func tearDown() {
        sut_showPostDetailUseCase = nil
        realm = nil
    }
    
    func test_getUser_ReturnsCorrectUser() {
        
        // Load test data to realm via LoadPostsUseCase
        let success = try! loadPostsUseCase.loadPosts().toBlocking().first()!
        XCTAssertTrue(success, "loadPosts fails and returns false")
        
        let user = try! sut_showPostDetailUseCase.getUser(userId: 2).toBlocking().first()!
        XCTAssertEqual(user.id, 2, "User Id does not match")
    }

    func test_getComments_ReturnsCorrectNumberOfComments() {
        
        // Load test data to realm via LoadPostsUseCase
        let success = try! loadPostsUseCase.loadPosts().toBlocking().first()!
        XCTAssertTrue(success, "loadPosts fails and returns false")
        
        let testNoOfComments = 5
        let comments = try! sut_showPostDetailUseCase.getComments(postId: 5).toBlocking().first()!
        XCTAssertEqual(comments.count, testNoOfComments, "No of comments does not match")
    }

}
