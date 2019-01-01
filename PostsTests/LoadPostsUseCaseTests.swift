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
        mockNetwork = MockNetwork()
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

    func test_loadPosts_CreatesPostsInRepository() {
        
        let success = try! sut_loadPostsUseCase.loadPosts().toBlocking().first()!
        XCTAssertTrue(success, "loadPosts fails and returns false")
        
        // Get post count in test data
        let testPostsCount = TestData.getPosts().count

        let posts = realm.objects(RMPost.self)
        XCTAssertEqual(posts.count, testPostsCount, "Posts count does not match with test data count")
    }
    
    func test_loadPosts_onErrorLogsError() {
        
        let mockThrowErrorNetwork = MockThrowsErrorNetwork()
        let postsNetwork = DefaultPostsNetwork(network: mockThrowErrorNetwork)
        
        let repository = RealmRepository()
        let postsRepository = DefaultPostsRepository(repository: repository)

        // Recreate sut using mockThrowErrorNetwork
        sut_loadPostsUseCase = DefaultLoadPostsUseCase(network: postsNetwork, repository: postsRepository)
        
        // Set mock error handler
        let mockErrorHandler = MockErrorHandler()
        sut_loadPostsUseCase.errorHandler = mockErrorHandler

        var isError = false
        do {
            _ = try sut_loadPostsUseCase.loadPosts().toBlocking().first()!
        } catch {
            isError = true
            XCTAssertNotNil(mockErrorHandler.error, "Error not handled correctly")
        }
        XCTAssertTrue(isError, "Error not thrown")
    }

}

class MockErrorHandler: ErrorHandler {
    
    var error:Error? = nil
    
    func submit(error: Error, type: ErrorType) {
        self.error = error
    }
    
}
