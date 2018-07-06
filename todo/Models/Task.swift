//
//  Task.swift
//  todo
//
//  Created by 中村太一 on 2018/05/26.
//  Copyright © 2018年 中村太一. All rights reserved.
//

import UIKit

class Task: Codable{
    var id: String?
    var title: String = ""
    var note: String = ""
    
    var latitude: Double?
    var longitude: Double?
    
    
    init(title: String) {
        self.title = title
    }
    
    init(id: String, data: [String: Any]) {
        self.id = id
        title = data["title"] as! String
        note = data["note"] as! String
        latitude = data["latitude"] as? Double
        longitude = data["longitude"] as? Double
    }
    
    
    func toJSON () -> String?{
        // こんな風に作ることもできるが面倒くさい
        // return "{\"title\":\"\(title)\"}"
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(self)
        return String(data: jsonData, encoding: String.Encoding.utf8)
    }
    
    func toDictionary () -> [String: Any] {
        return [
            "title": title,
            "note": note,
            "latitude": latitude!,
            "longitude": longitude!
        ]
    }
    
    
}
