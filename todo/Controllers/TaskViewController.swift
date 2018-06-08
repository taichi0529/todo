//
//  AddViewController.swift
//  todo
//
//  Created by 中村太一 on 2018/05/26.
//  Copyright © 2018年 中村太一. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController, UITextFieldDelegate {
    let taskCollection = TaskCollection.sharedInstance
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
    var selectedTask: Task? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let selectedTask = self.selectedTask {
            self.title = "編集"
            self.titleTextField.text = selectedTask.title
            self.noteTextView.text = selectedTask.note
        }

        titleTextField.delegate = self
        
        // Do any additional setup after loading the view.
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    //画面をタップすると、キーボードが閉じる動作
    @objc func tapGesture(sender: UITapGestureRecognizer) {
        titleTextField.resignFirstResponder()
    }
    
    //リターンをタップすると、キーボードが閉じる動作
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func didTouchSaveButton(_ sender: Any) {
        let title = titleTextField.text!
        if title.isEmpty {
            showAlert("エラー", "タイトルを入力して下さい。")
            return
        }
        
        if let selectedTask = self.selectedTask {
            selectedTask.note = noteTextView.text
        } else {
            let task = Task(title: title)
            task.note = noteTextView.text
            taskCollection.addTask(task)
        }
        taskCollection.save()
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlert(_ title: String, _ text: String){
        let alertController = UIAlertController(title: title, message: text , preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) -> Void in
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
