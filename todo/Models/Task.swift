//
//  Task.swift
//  todo
//
//  Created by 中村太一 on 2018/05/26.
//  Copyright © 2018年 中村太一. All rights reserved.
//

import UIKit

class Task: NSObject, NSCoding{
    var title: String = ""
    init(title: String) {
        self.title = title
    }
    required init(coder decoder: NSCoder) {
        self.title = decoder.decodeObject(forKey: "title") as? String ?? ""
    }
    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: "title")
    }
}
