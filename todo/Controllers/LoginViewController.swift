//
//  LoginViewController.swift
//  todo
//
//  Created by 中村太一 on 2018/06/15.
//  Copyright © 2018年 中村太一. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTouchNewButton(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        if email.isEmpty {
            self.alert("エラー", "メールアドレスを入力して下さい", nil)
            return
        }
        if password.isEmpty {
            self.alert("エラー", "パスワードを入力して下さい", nil)
            return
        }
        User.shared.createUser(withEmail: email, password: password) { (error) in
            if let error = error {
//                self.alert("エラー", "アカウントの作成に失敗しました", nil)
                self.alert("エラー", error.localizedDescription, nil)
                return
            }
            self.presentTaskTable()
            return
        }
    }
    @IBAction func didTouchLoginButton(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        if email.isEmpty {
            self.alert("エラー", "メールアドレスを入力して下さい", nil)
            return
        }
        if password.isEmpty {
            self.alert("エラー", "パスワードを入力して下さい", nil)
            return
        }
        
        
        
        User.shared.signIn(withEmail: email, password: password) { (error) in
            if let error = error {
                //                self.alert("エラー", "アカウントの作成に失敗しました", nil)
                self.alert("エラー", error.localizedDescription, nil)
                return
            }
            self.presentTaskTable()
            return
        }
    }
    
    func presentTaskTable () {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TaskNavigationController")
        self.present(viewController!, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
