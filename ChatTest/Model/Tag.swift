//
//  Tag.swift
//  ChatTest
//
//  Created by Admin on 01.09.2018.
//  Copyright © 2018 Maksim Khozyashev. All rights reserved.
//

import UIKit

final class Tag {
    
    let label: String
    let color: UIColor?
    
    init(label: String, color: UIColor?) {
        self.label = label
        self.color = color
    }
}

final class TagParser {
    
    static func parse(_ json: JSON) -> Tag {
        let label = json["label"].stringValue
        let rawColor = json["color"].string
        var color: UIColor? = nil
        if rawColor != nil {
            color = ColorHelper.colorFrom(hexString: rawColor!)
        }

        return Tag(label: label, color: color)
    }
    
    static func parseArray(_ jsonArray: [JSON]) -> [Tag] {
        var tagsArray = [Tag]()
        jsonArray.forEach{ json in
            let tag = parse(json)
            tagsArray.append(tag)
        }
        return tagsArray
    }
}
