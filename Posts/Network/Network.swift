//
//  Network.swift
//  Posts
//
//  Created by Samson Lopez on 30/12/2018.
//  Copyright © 2018 Samson Lopez. All rights reserved.
//

import Foundation
import RxSwift

public protocol Network {
    func getData<T: Codable>(at url:URL) -> Observable<[T]>
}

// Concrete implementation of Network with REST based on URLSession

public class RESTNetwork: Network {
    
    var urlSession: URLSession
    
    init(urlSession: URLSession) {
        self .urlSession = urlSession
    }
    
    // Generic method for retrieving entities from network
    public func getData<T: Codable>(at url:URL) -> Observable<[T]> {
        let request = URLRequest(url: url)
        return urlSession
            .rx.data(request: request)
            .map { data in
                do {
                    let decoder = JSONDecoder()
                    let entity = try decoder.decode([T].self, from: data)
                    return entity.map {
                        return $0
                    }
                    
                } catch let error {
                    throw error
                }
        }
    }
    
}
