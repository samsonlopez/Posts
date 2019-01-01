//
//  TestData.swift
//  PostsTests
//
//  Created by Samson Lopez on 30/12/2018.
//  Copyright © 2018 Samson Lopez. All rights reserved.
//

import Foundation

@testable import Posts

// Provides test data from a static JSON files.

class TestData {

    static func getPosts() -> [Post] {
        return getEntites(url: URL(string: PostsURLSettings.posts)!)
    }

    static func getUsers() -> [User] {
        return getEntites(url: URL(string: PostsURLSettings.users)!)
    }

    static func getComments() -> [Comment] {
        return getEntites(url: URL(string: PostsURLSettings.comments)!)
    }

    static func getEntites<T: Codable>(url: URL) -> [T] {
        var entities: [T]!
        
        let testData = TestData.getTestData(url: url)
        do {
            let decoder = JSONDecoder()
            entities = try decoder.decode([T].self, from: testData)
        } catch let error {
            print(error)
        }
        
        return entities
    }

    static func getTestData(url:URL) -> Data {
        
        let filename = url.lastPathComponent
        
        let path = Bundle.main.path(forResource: filename, ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        
        return data
    }
    
}
