//
//  User.swift
//  todo
//
//  Created by 中村太一 on 2018/06/15.
//  Copyright © 2018年 中村太一. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
// こういう風にUserのモデルでまとめればコントローラーの肥大化や、ログインに使う方法を変えたときに便利
class User {
    static let shared = User()
    private init(){}
    
    var currentUser:  FirebaseAuth.User?
    
    func createUser (withEmail: String, password: String, completion: @escaping ((_ error: Error?) -> Void)) {
        Auth.auth().createUser(withEmail: withEmail, password: password) { (user, error) in
            if let error = error {
                completion(error)
                return
            }
            self.currentUser = user?.user
            completion(nil)
            
        }
    }
    
    func signIn (withEmail: String, password: String, completion: @escaping ((_ error: Error?) -> Void)) {
        Auth.auth().signIn(withEmail: withEmail, password: password) { (user, error) in
            if let error = error {
                completion(error)
                return
            }
            self.currentUser = user?.user
            completion(nil)
            
        }
    }
    
    func isLogined () -> Bool {
        if let _ = Auth.auth().currentUser {
            return true
        }
        return false
    }
}
