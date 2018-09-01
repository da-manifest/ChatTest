//
//  DS24Service.swift
//  ChatTest
//
//  Created by Admin on 01.09.2018.
//  Copyright © 2018 Maksim Khozyashev. All rights reserved.
//

import Foundation
import RxSwift

final class DS24Service {
    
    static func getMessages(offset: Int) -> Observable<[Message]> {
        return API.perform(method: "list.php?offset=\(offset)&limit=10")
            .flatMap { json -> Observable<[Message]> in
                let rawMessages = json["data"].arrayValue
                let messages = MessageParser.parseArray(rawMessages)
                return Observable.just(messages)
        }
    }
    
    static func getMessageDetails(id: Int) -> Observable<Message> {
        return API.perform(method: "detail.php?id=\(id)")
            .flatMap { json -> Observable<Message> in
                if let rawMessage = json["data"].arrayValue.first {
                    let message = MessageParser.parse(rawMessage)
                    return Observable.just(message)
                }
                return Observable.error(APIError.unknown)
        }
    }
}
