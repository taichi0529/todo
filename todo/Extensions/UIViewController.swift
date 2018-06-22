//
//  UIView.swift
//  pubrepo
//
//  Created by 中村太一 on 2017/12/25.
//  Copyright © 2017年 Asaichi LLC. All rights reserved.
//

import UIKit
extension UIViewController {
    func alert(_ title: String, _ message: String, _ closedHandler: (()->Void)?) {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            print("閉じる")
            if let closedHandler = closedHandler {
                closedHandler()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
