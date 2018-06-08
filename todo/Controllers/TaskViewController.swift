//
//  AddViewController.swift
//  todo
//
//  Created by 中村太一 on 2018/05/26.
//  Copyright © 2018年 中村太一. All rights reserved.
//

import UIKit
import GoogleMaps

class TaskViewController: UIViewController, UITextFieldDelegate, GMSMapViewDelegate, CLLocationManagerDelegate {
    let taskCollection = TaskCollection.sharedInstance
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var mapCanvasView: UIView!
    
    let marker = GMSMarker()
    
    var locationManager = CLLocationManager()
    var currentLocation:CLLocation? = nil
    var mapView: GMSMapView!
    var zoomLevel: Float = 14.0
    let defaultLatitude = 35.6675497
    let defaultLongitude = 139.7137988
    
    var selectedTask: Task? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.delegate = self
        
        // Do any additional setup after loading the view.
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        self.view.addGestureRecognizer(tapRecognizer)
        
        let camera = GMSCameraPosition.camera(withLatitude: self.defaultLatitude,
                                              longitude: self.defaultLongitude,
                                              zoom: zoomLevel)
        self.mapView = GMSMapView.map(withFrame: mapCanvasView.bounds, camera: camera)
        // 自分の場所を中心に合わせるボタン
//        self.mapView.settings.myLocationButton = true
        // 自分の場所を表示する
//        self.mapView.isMyLocationEnabled = true
//                self.mapView.translatesAutoresizingMaskIntoConstraints = false
//                self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.mapView.delegate = self
        
        mapCanvasView.addSubview(self.mapView)
        
        
        // 自分の場所を取得
        // https://dev.classmethod.jp/smartphone/ios-corelocation-swift3/
        self.locationManager = CLLocationManager()
        // 更新頻度や精度で消費電力がかわってくる
        // 位置情報の更新をどれ位一時停止出来るかを判断 自動車用、歩行者用等など
        self.locationManager.activityType = .other
        // 精度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 更新イベントの生成に必要な、水平方向の最小移動距離（メートル単位）
        self.locationManager.distanceFilter = 50
        // 開始
        self.locationManager.startUpdatingLocation()
        // delegate
        self.locationManager.delegate = self
        
        marker.tracksViewChanges = false
        marker.isDraggable = true
        marker.position.latitude = self.defaultLatitude
        marker.position.longitude = self.defaultLongitude

        
        if let selectedTask = self.selectedTask {
            self.title = "編集"
            self.titleTextField.text = selectedTask.title
            self.noteTextView.text = selectedTask.note
            if let latitude = selectedTask.latitude, let longitude = selectedTask.longitude {
                marker.position.latitude = latitude
                marker.position.longitude = longitude
                self.mapView.camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: self.zoomLevel)
            }
        }
        
        marker.map = self.mapView
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
            selectedTask.note = noteTextView.text
            selectedTask.latitude = marker.position.latitude
            selectedTask.longitude = marker.position.longitude
        } else {
            let task = Task(title: title)
            task.note = noteTextView.text
            task.latitude = marker.position.latitude
            task.longitude = marker.position.longitude
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
