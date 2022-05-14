//
//  mainVC.swift
//  Study Time
//
//  Created by Caleb Arendse on 9/23/17.
//  Copyright © 2017 Caleb Arendse. All rights reserved.
//

import UIKit
import AVKit
import Firebase

class mainVC:UIViewController {
    @IBOutlet weak var unLabel: UILabel!
    @IBOutlet weak var capturePreviewView: UIView!
    @IBOutlet weak var buddyView: UIView!
    
    let cameraController = CameraController()
    var refUsers: DatabaseReference!
    let tb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "toolVC") as! toolOverlayView
    
    override func viewDidLoad() {
        configureCameraController()

        if Auth.auth().currentUser != nil {
        let userID:String = (Auth.auth().currentUser?.uid)!
        refUsers = Database.database().reference().child("Users").child(userID);
        refUsers.observeSingleEvent(of: .value, with: {(snapshot) in
            if !snapshot.exists(){ return }
            let uName = snapshot.childSnapshot(forPath: "username").value as! String
            print(uName)
            self.unLabel.text = uName
        })
        }
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "studyStart")
            self.addChildViewController(popOverVC)
            popOverVC.view.frame = self.view.frame
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParentViewController: self)
        
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func srink(){
        UIView.animate(withDuration: 0.5, animations:{
            self.capturePreviewView.frame.size.height -= 501
            self.capturePreviewView.frame.size.width -= 239
        })
    }
    
    func configureCameraController(){
        cameraController.prepare{(error) in
            if let error = error {
                print(error)
            }
            try? self.cameraController.displayPreview(on: self.capturePreviewView)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openToolbox(_ sender: Any) {
        self.addChildViewController(tb)
        self.view.addSubview(tb.view)
    }
    
    @IBAction func raprap(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations:{
            self.capturePreviewView.frame.size.height -= 501
            self.capturePreviewView.frame.size.width -= 239
        })
        
    }
}

