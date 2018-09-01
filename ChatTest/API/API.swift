//
//  API.swift
//  ChatTest
//
//  Created by Admin on 01.09.2018.
//  Copyright © 2018 Maksim Khozyashev. All rights reserved.
//

import Foundation
import RxSwift

final class APIURLSession: URLSession, URLSessionDelegate {
    static let apiShared = APIURLSession()
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        return session.dataTask(with: request, completionHandler: completionHandler)
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(
            .useCredential,
            URLCredential(trust: challenge.protectionSpace.serverTrust!)
        )
    }
}

final class API {
    
    typealias Response = Observable<JSON>
    
    static func perform(method: String) -> Response {
        let request = createRequest(method, timeoutInterval: 30)
        return performRequest(request).map { $0 }
    }
}

// MARK: - Private
private extension API {
    
    static var apiAddress: String {
        return Bundle.main.object(forInfoDictionaryKey: "DS24_ENDPOINT") as! String
    }
    
    static func performRequest(_ request: URLRequest) -> Response {
        let observable = APIURLSession.apiShared.rx.response(request: request)
            .flatMapLatest { (response, data) -> Response in
                let parsed = parse(data: data, response: response)
                return parsed
            }.catchError { error in
                let apiError = APIError.get(byError: error)
                return Observable.error(apiError)
        }
        
        return observable
    }
    
    static func createRequest(_ method: String, timeoutInterval: TimeInterval) -> URLRequest {
        let url: String = apiAddress + method
        let requestAdress: URL = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)!
        var request: URLRequest = URLRequest(url: requestAdress)
        request.timeoutInterval = timeoutInterval
        request.httpMethod = "GET"
        return request
    }
    
    static func parse(data: Data, response: HTTPURLResponse) -> Response {
        let json = JSON(data: data)
        
        if let error = APIError(json: json) {
            return Observable.error(error)
        }
        return Observable.just(json)
    }
}
