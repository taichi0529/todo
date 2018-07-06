//
//  Task.swift
//  todo
//
//  Created by 中村太一 on 2018/05/26.
//  Copyright © 2018年 中村太一. All rights reserved.
//

import UIKit

class Task: NSObject, NSCoding{
    var id: String?
    var title: String = ""
    var note: String = ""
    
    var latitude: Double?
    var longitude: Double?
    
    var imageUrl: String?
    var image: UIImage?
    
    
    init(title: String) {
        self.title = title
    }
    
    deinit {
        print ("taskのインスタンスが破棄されました")
    }
    
    init(data: [String: Any]) {
        if let title = data["title"] as? String {
            self.title = title
        }
        if let note = data["note"] as? String {
            self.note = note
        }
        if let latitude = data["latitude"] as? Double {
            self.latitude = latitude
        }
        if let longitude = data["longitude"] as? Double {
            self.longitude = longitude
        }
    }
    
    required init(coder decoder: NSCoder) {
        self.title = decoder.decodeObject(forKey: "title") as? String ?? ""
        self.note = decoder.decodeObject(forKey: "note") as? String ?? ""
        self.latitude = decoder.decodeObject(forKey: "latitude") as? Double ?? nil
        self.longitude = decoder.decodeObject(forKey: "longitude") as? Double ?? nil
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: "title")
        coder.encode(note, forKey: "note")
        coder.encode(latitude, forKey: "latitude")
        coder.encode(longitude, forKey: "longitude")
    }
    
    func toData() -> [String: Any] {
        return [
            "title": self.title,
            "note": self.note,
            "latitude": self.latitude!,
            "longitude": self.longitude!
        ]
    }
    
    
}
