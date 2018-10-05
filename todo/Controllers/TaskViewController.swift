//
//  AddViewController.swift
//  todo
//
//  Created by 中村太一 on 2018/05/26.
//  Copyright © 2018年 中村太一. All rights reserved.
//

import UIKit
import GoogleMaps

class TaskViewController: UIViewController, UITextFieldDelegate, GMSMapViewDelegate, CLLocationManagerDelegate,
UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let taskCollection = TaskCollection.shared
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var mapCanvasView: UIView!
    @IBOutlet weak var todoImageView: UIImageView!
    
    
    let marker = GMSMarker()
    
    var locationManager = CLLocationManager()
    var currentLocation:CLLocation? = nil
    var mapView: GMSMapView!
    var zoomLevel: Float = 14.0
    let defaultLatitude = 35.6675497
    let defaultLongitude = 139.7137988
    
    var selectedTask: Task? = nil
    
    var changeImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(sender:)))
        todoImageView.isUserInteractionEnabled = true
        todoImageView.addGestureRecognizer(tapGestureRecognizer)
        
        
        
        self.marker.position.latitude = self.defaultLatitude
        self.marker.position.longitude = self.defaultLongitude
        
        if let selectedTask = self.selectedTask {
            self.title = "編集"
            titleTextField.text = selectedTask.title
            noteTextView.text = selectedTask.note
            if let latitude = selectedTask.latitude, let longitude = selectedTask.longitude {
                self.marker.position.latitude = latitude
                self.marker.position.longitude = longitude
            }
            
            selectedTask.loadImage(imageView: todoImageView)
            
        }

        // Do any additional setup after loading the view.
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        self.view.addGestureRecognizer(tapRecognizer)
        
        //        let camera = GMSCameraPosition.camera(withLatitude: defaultLatitude,
        //                                              longitude: defaultLongitude,
        //                                              zoom: 14)
        let camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: 15)
        self.mapView = GMSMapView.map(withFrame: mapCanvasView.bounds, camera: camera)
        
        // 自分の場所を中心に合わせるボタン
        self.mapView?.settings.myLocationButton = true
        // 自分の場所を表示する
        self.mapView?.isMyLocationEnabled = true
        
        self.mapView?.delegate = self
        
        mapCanvasView.addSubview(self.mapView!)
        
        // 自分の場所を取得
        // https://dev.classmethod.jp/smartphone/ios-corelocation-swift3/
        //        self.locationManager = CLLocationManager()
        // 更新頻度や精度で消費電力がかわってくる
        // 位置情報の更新をどれ位一時停止出来るかを判断 自動車用、歩行者用等など
        self.locationManager.activityType = .other
        // 精度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 更新イベントの生成に必要な、水平方向の最小移動距離（メートル単位）
        self.locationManager.distanceFilter = 50
        // 開始
        self.locationManager.startUpdatingLocation()
        
        
        self.marker.map = self.mapView
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title:"", message: "選択してください", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "カメラ", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            print("カメラ")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let cameraPicker = UIImagePickerController()
                cameraPicker.sourceType = UIImagePickerControllerSourceType.camera
                cameraPicker.delegate = self
                self.present(cameraPicker, animated: true, completion: nil)
                
            } else {
                print ("カメラ使えない")
            }

        }))
        alert.addAction(UIAlertAction(title: "アルバム", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            print("アルバム")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let cameraPicker = UIImagePickerController()
                cameraPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                cameraPicker.delegate = self
                self.present(cameraPicker, animated: true, completion: nil)
                
            } else {
                print ("アルバム使えない")
            }
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
            print("キャンセル")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    //　撮影もしくは画像を選択したら呼ばれる
    func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            todoImageView.contentMode = .scaleAspectFit
            todoImageView.image = pickedImage.resize(size: CGSize(width: 300, height: 300))
            self.changeImage = true
        }
        
        //閉じる処理
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    //画面をタップすると、キーボードが閉じる動作
    @objc func tapGesture(sender: UITapGestureRecognizer) {
        titleTextField.resignFirstResponder()
        noteTextView.resignFirstResponder()
    }
    
    //リターンをタップすると、キーボードが閉じる動作
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /// マーカー以外をタップしたら
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.marker.position = coordinate
    }
    
    
    @IBAction func didTouchSaveButton(_ sender: Any) {
        let title = titleTextField.text!
        if title.isEmpty {
            showAlert("エラー", "タイトルを入力して下さい。")
            return
        }
        
        print (self.marker.position.latitude)
        
        if let selectedTask = self.selectedTask {
            selectedTask.title = title
            selectedTask.note = noteTextView.text
            selectedTask.latitude = marker.position.latitude
            selectedTask.longitude = marker.position.longitude
            if changeImage {
                selectedTask.image = todoImageView.image
            }
        } else {
            let task = Task(title: title)
            task.note = noteTextView.text
            task.latitude = marker.position.latitude
            task.longitude = marker.position.longitude
            if changeImage {
                task.image = todoImageView.image
            }
            taskCollection.addTask(task)
        }
        taskCollection.save()
        changeImage = false
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
