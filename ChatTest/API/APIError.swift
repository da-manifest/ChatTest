//
//  APIError.swift
//  ChatTest
//
//  Created by Admin on 01.09.2018.
//  Copyright © 2018 Maksim Khozyashev. All rights reserved.
//

import Foundation
import RxCocoa

struct APIError: Error {
    
    private let description: String
    
    private init(_ description: String) {
        self.description = description
    }
    
    static func description(_ error: Error) -> String {
        return (error as? APIError)?.description ?? error.localizedDescription
    }
    
    static func failure(reason: String) -> APIError {
        return APIError(reason)
    }
}

// MARK: Common errors
extension APIError {
    
    static var unknown: APIError { return APIError("Unknown error") }
    private static var noInternetConnection: APIError { return APIError("Check internet connection") }
    private static var requestTimedOut: APIError { return APIError("Request timed out") }
}

// MARK: Parsing
extension APIError {

    init?(json: JSON) {
        guard let description = json["err"].string else { return nil }
        self.description = description
    }

    static func get(byError error: Error) -> APIError {
        if let apiError = error as? APIError {
            return apiError
        }
        switch (error as NSError).code {
        case -1009:
            return .noInternetConnection
        case -1001:
            return .requestTimedOut
        default:
            return .failure(reason: error.localizedDescription)
        }
    }
}
