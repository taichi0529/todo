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
    
    func getTaskCollectionRef() -> CollectionReference? {
        guard let uid = User.shared.getUid() else {
            print ("error")
            return nil
        }
        return db.collection("data").document(uid).collection("task")
    }
    
    func save () {
//        // シリアル化
//        let data = NSKeyedArchiver.archivedData(withRootObject: tasks)
//        //UserDefaultsにtasksという名前で保存
//        UserDefaults.standard.set(data, forKey: "tasks")

        
        guard let taskRef = getTaskCollectionRef() else {
            print ("dddddddddddddddddddddddddddd")
            return
        }
        
        tasks.forEach { (task) in
            if let id = task.id {
                taskRef.document(id).setData(task.toDictionary())
            } else {
                var ref: DocumentReference? = nil
                ref = taskRef.addDocument(data: task.toDictionary()){ err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                        task.id = ref!.documentID
                    }
                }
            }
        }
        
    }
    
    func clear () {
        tasks = []
    }
    
    func load (completion: @escaping ((_ error: Error?) -> Void)) {
        guard let taskRef = getTaskCollectionRef() else {
            return
        }
        
        taskRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(err)
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    if document.exists {
                        self.addTask(Task(id: document.documentID, data: document.data()))
                    } else {
                        print("Document does not exist")
                    }
                }
                completion(nil)
            }
        }
        
        // UserDefaultsからtasksというキーでデータを取得
//        if let data = UserDefaults.standard.data(forKey: "tasks") {
//            // 取得したデータをTaskの配列に変換
//            if let tasks = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Task] {
//                self.tasks = tasks
//            }
//        }
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

