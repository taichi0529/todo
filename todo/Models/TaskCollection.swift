//
//  TaskCollection.swift
//  todo
//
//  Created by 中村太一 on 2018/05/26.
//  Copyright © 2018年 中村太一. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class TaskCollection {
    var tasks:[Task] = []
    
    static let shared = TaskCollection()
    private init(){}
    
    let db = Firestore.firestore()
    
    //タスクの追加
    func addTask(_ task: Task) {
        tasks.append(task)
    }
    
    func save () {
        // シリアル化
        let data = NSKeyedArchiver.archivedData(withRootObject: tasks)
        //UserDefaultsにtasksという名前で保存
        UserDefaults.standard.set(data, forKey: "tasks")
    }
    
    func load () {
        // UserDefaultsからtasksというキーでデータを取得
        if let data = UserDefaults.standard.data(forKey: "tasks") {
            // 取得したデータをTaskの配列に変換
            if let tasks = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Task] {
                self.tasks = tasks
            }
        }
    }
    
    // タスクの数
    func count() -> Int {
        return tasks.count
    }
    
    // タスクの取得
    func getTask(at: Int) -> Task {
        return tasks[at]
    }
    
}

