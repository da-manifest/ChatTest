//
//  Message.swift
//  ChatTest
//
//  Created by Admin on 01.09.2018.
//  Copyright © 2018 Maksim Khozyashev. All rights reserved.
//

import Foundation

final class Message {
    
    let tagList: [Tag]?
    let dateCreated: String?
    let id: Int
    let isLeftSide: Bool
    let text: String
    
    init(id: Int, isLeftSide: Bool, text: String, dateCreated: String?, tagList: [Tag]?) {
        self.id = id
        self.isLeftSide = isLeftSide
        self.text = text
        self.dateCreated = dateCreated
        self.tagList = tagList
    }
}

final class MessageParser {
    
    static func parse(_ json: JSON) -> Message {
        let id = json["id"].intValue
        let rawIsLeftSide = json["createdBy"].intValue
        let isLeftSide = rawIsLeftSide == 0 ? true : false
        let text = json["text"].stringValue
        let dateCreated = json["createdAt"].stringValue
        let rawTagList = json["tagList"].array
        var tagList: [Tag]? = nil
        if rawTagList != nil {
            tagList = TagParser.parseArray(rawTagList!)
        }
        
        return Message(id: id,
                       isLeftSide: isLeftSide,
                       text: text,
                       dateCreated: dateCreated,
                       tagList: tagList)
    }
    
    static func parseArray(_ jsonArray: [JSON]) -> [Message] {
        var messagesArray = [Message]()
        jsonArray.forEach{ json in
            let message = parse(json)
            messagesArray.append(message)
        }
        return messagesArray
    }
}
