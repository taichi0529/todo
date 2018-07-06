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
    
    //タスクの追加
    func addTask(_ task: Task) {
        tasks.append(task)
    }
    
    let db = Firestore.firestore()
    
    func getCollectionRef () -> CollectionReference? {
        guard let uid = User.shared.getUid() else {
            print ("Uidを取得出来ませんでした。")
            return nil
        }
        return db.collection("list").document(uid).collection("task")
    }
    
    func save () {
        let collectionRef = getCollectionRef()
        tasks.forEach { (task) in
            
            if let id = task.id {
                let documentRef = collectionRef?.document(id)
                documentRef?.setData(task.toData())
                
            } else {
                
                let documentRef = collectionRef?.addDocument(data: task.toData())
                task.id = documentRef?.documentID
            }
        }
    }
    
    func load (completion: @escaping ()->Void) {
        let collectionRef = getCollectionRef()
        collectionRef?.getDocuments { (querySnapshot, error) in
            if let error = error {
                print (error.localizedDescription)
                return
            }
            if let documents = querySnapshot?.documents {
                documents.forEach({ (document) in
                    if document.exists {
                        let data = document.data()
                        let task = Task(data: data)
                        self.addTask(task)
                    }
                })
            }
            completion()
        }
        
    }
    
    func clear() {
        tasks = []
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
