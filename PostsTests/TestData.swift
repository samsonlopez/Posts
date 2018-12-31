//
//  TestData.swift
//  PostsTests
//
//  Created by Samson Lopez on 30/12/2018.
//  Copyright © 2018 Samson Lopez. All rights reserved.
//

import Foundation

@testable import Posts

// Provides test data from a static JSON file.

class TestData {

    static func getPosts() -> [Post] {
        return getEntites(for: "posts")
    }

    static func getEntites<T: Codable>(for filename:String) -> [T] {
        var entities: [T]!
        
        let testData = TestData.getTestData(for: filename)
        do {
            let decoder = JSONDecoder()
            entities = try decoder.decode([T].self, from: testData)
        } catch let error {
            print(error)
        }
        
        return entities
    }

    static func getTestData(for filename:String) -> Data {
        let path = Bundle.main.path(forResource: filename, ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        
        return data
    }
    
}
