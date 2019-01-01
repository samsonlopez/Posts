//
//  MockSession.swift
//  PostsTests
//
//  Created by Samson Lopez on 30/12/2018.
//  Copyright © 2018 Samson Lopez. All rights reserved.
//

import Foundation
import RxSwift

@testable import Posts

// Mock network used for testing, loads test data from file.

class MockNetwork: Network {
    
    let filename: String
    var entityCount: Int = 0
    
    init(filename: String) {
        self.filename = filename
    }
    
    public func getData<T: Codable>(at url:URL) -> Observable<[T]> {
        return Observable.create { observer in
            
            let testData = TestData.getTestData(for: self.filename)
            
            var entities: [T]!
            do {
                let decoder = JSONDecoder()
                entities = try decoder.decode([T].self, from: testData)
            } catch let error {
                print(error)
            }
            
            self.entityCount = entities.count
            
            observer.on(.next(entities))
            observer.on(.completed)
            
            return Disposables.create()
            
        }
    }
    
}

class MockThrowsErrorNetwork: Network {
    
    let filename: String
    var entityCount: Int = 0
    
    init(filename: String) {
        self.filename = filename
    }
    
    public func getData<T: Codable>(at url:URL) -> Observable<[T]> {
        return Observable.create { observer in
            observer.onError(RepositoryError.notAccessible);
            
            return Disposables.create()
        }
    }
    
}
