//
//  TaskCollection.swift
//  todo
//
//  Created by 中村太一 on 2018/05/26.
//  Copyright © 2018年 中村太一. All rights reserved.
//

import UIKit

class TaskCollection {
    
    //シングルトンなインスタンスを定義
    static let sharedInstance = TaskCollection()
    //外部からのインスタンス作成を禁止
    private init(){}
    //Realmで使う配列宣言（List<>にする）
    var tasks:[Task] = []
    let userDefaults = UserDefaults.standard
    
    
    
    //タスクを登録する関数
    func addTask(_ task: Task){
        self.tasks.append(task)
        let data = NSKeyedArchiver.archivedData(withRootObject: tasks)
        userDefaults.set(data, forKey: "tasks")
    }
    
    func getTask(at: Int) -> Task{
        return tasks[at]
    }
    
    //タスクの数を返す関数
    func count() -> Int {
        return tasks.count
    }
    
    func load() {
        if let data = UserDefaults.standard.data(forKey: "tasks") {
            if let tasks = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Task] {
                self.tasks = tasks
            }
        }
    }
    
    
}
