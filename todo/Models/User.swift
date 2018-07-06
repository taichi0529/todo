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
    
    private var currentUser:  FirebaseAuth.User?
    
    private init(){
        self.currentUser = Auth.auth().currentUser
    }
    
    func getUid () -> String? {
        if let user = self.currentUser {
            return user.uid
        }
        return nil
    }
    
    func signOut () {
        try! Auth.auth().signOut()
    }
    
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
        if let _ = self.currentUser {
            return true
        }
        return false
    }
}
