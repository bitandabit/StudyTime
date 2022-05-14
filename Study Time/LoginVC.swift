//
//  LoginVC.swift
//  Study Time
//
//  Created by Caleb Arendse on 9/25/17.
//  Copyright © 2017 Caleb Arendse. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var mainSquare: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainSquare.layer.cornerRadius = 8.0
        loginBtn.layer.cornerRadius = 8.0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        if self.usernameTextField.text == "" || self.passwordTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().signIn(withEmail: self.usernameTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    print("Successfully logged in")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "pageView")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
    }
    @IBAction func ttapOut(_ sender: Any) {
        self.view.endEditing(true)
    }
}
