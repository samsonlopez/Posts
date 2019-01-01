//
//  ErrorHandler.swift
//  Posts
//
//  Created by Samson Lopez on 01/01/2019.
//  Copyright © 2019 Samson Lopez. All rights reserved.
//

import Foundation

public enum ErrorType {
    case alert
    case log
}

public protocol ErrorHandler: class {
    func submit(error: Error, type: ErrorType)
}

// Posts loader service to retrieve and load posts into repository

final public class DefaultErrorHandler: ErrorHandler {
    
    // Singleton to expose and access the error handler
    static let shared = DefaultErrorHandler()
    
    public func submit(error: Error, type: ErrorType) {
        switch type {
        case .alert:
            alert(error: error)
        case .log:
            log(error: error)
        }
    }
    
    // Object creation not allowed external to class. Access only through shared singleton
    private init() {
    }
    
    private func alert(error: Error) {
        // TODO : Implement alerts
        print(error)
    }

    private func log(error: Error) {
        // TODO : Implement error logging
        print(error)
    }

}
