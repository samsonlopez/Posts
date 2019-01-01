//
//  LoadPostsUseCaseTests.swift
//  PostsTests
//
//  Created by Samson Lopez on 30/12/2018.
//  Copyright © 2018 Samson Lopez. All rights reserved.
//

import XCTest
import RxSwift
import RealmSwift
import RxBlocking
@testable import Posts

class LoadPostsUseCaseTests: XCTestCase {

    var sut_loadPostsUseCase: LoadPostsUseCase!
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
        
        sut_loadPostsUseCase = DefaultLoadPostsUseCase(network: postsNetwork, repository: postsRepository)
    }

    override func tearDown() {
        sut_loadPostsUseCase = nil
        realm = nil
    }

    func testLoadPosts_CreatesPostsInRepository() {
        
        let success = try! sut_loadPostsUseCase.loadPosts().toBlocking().first()!
        XCTAssertTrue(success, "loadPosts fails and returns false")
        
        let posts = realm.objects(RMPost.self)
        XCTAssertEqual(posts.count, mockNetwork.entityCount, "Posts count does not match with test data count")
    }
    
    func testLoadPosts_onErrorLogsError() {
        
        let mockThrowErrorNetwork = MockThrowsErrorNetwork(filename: "posts")
        let postsNetwork = DefaultPostsNetwork(network: mockThrowErrorNetwork)
        
        let repository = RealmRepository()
        let postsRepository = DefaultPostsRepository(repository: repository)

        // Recreate sut using mockThrowErrorNetwork
        sut_loadPostsUseCase = DefaultLoadPostsUseCase(network: postsNetwork, repository: postsRepository)
        
        // Set mock error handler
        let mockErrorHandler = MockErrorHandler()
        sut_loadPostsUseCase.errorHandler = mockErrorHandler

        _ = try! sut_loadPostsUseCase.loadPosts().toBlocking().first()!

        XCTAssertNotNil(mockErrorHandler.error, "Error not handled correctly")
    }

}

class MockErrorHandler: ErrorHandler {
    
    var error:Error? = nil
    
    func submit(error: Error, type: ErrorType) {
        self.error = error
    }
    
}
