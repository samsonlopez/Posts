//
//  ListPostsUseCaseTests.swift
//  PostsTests
//
//  Created by Samson Lopez on 31/12/2018.
//  Copyright © 2018 Samson Lopez. All rights reserved.
//

import XCTest
import RxSwift
import RealmSwift
import RxBlocking
@testable import Posts

class ListPostsUseCaseTests: XCTestCase {
    
    var sut_listPostsUseCase: ListPostsUseCase!
    var loadPostsUseCase: LoadPostsUseCase!
    var mockNetwork: MockNetwork! // Also holds mock var entityCount on return
    var realm: Realm!
    
    override func setUp() {
        
        // Mock network to load test data from file
        mockNetwork = MockNetwork(filename: "posts")
        let postsNetwork = DefaultPostsNetwork(network: mockNetwork)
        
        // In-memory Realm for testing, loads clear each time
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "Posts-tests"
        realm = try! Realm()
        
        let repository = RealmRepository()
        let postsRepository = DefaultPostsRepository(repository: repository)
        loadPostsUseCase = DefaultLoadPostsUseCase(network: postsNetwork, repository: postsRepository)
        
        sut_listPostsUseCase = DefaultListPostsUseCase(repository: postsRepository)
    }
    
    override func tearDown() {
        sut_listPostsUseCase = nil
        realm = nil
    }
    
    func testGetPosts_CreatesPostsInRepository() {
        
        // Load test data to realm via LoadPostsUseCase
        let success = try! loadPostsUseCase.loadPosts().toBlocking().first()!
        XCTAssertTrue(success, "loadPosts fails and returns false")

        let posts = try! sut_listPostsUseCase.getPosts().toBlocking().first()!
        XCTAssertEqual(posts.count, mockNetwork.entityCount, "Posts count does not match with test data count")
    }
    
}
