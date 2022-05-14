//  signUpVC.swift
//  Study Time
//
//  Created by Caleb Arendse on 9/23/17.
//  Copyright © 2017 Caleb Arendse. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class signUpVC:UIViewController{
    
    @IBOutlet weak var litView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    var refUsers: DatabaseReference!
    
    @IBOutlet weak var signBtn: UIButton!
    
    override func viewDidLoad() {
        litView.layer.cornerRadius = 8.0
        refUsers = Database.database().reference().child("Users");
        super.viewDidLoad()
        signBtn.layer.cornerRadius = 8.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if usernameTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    print("Successfully signed up")
                    self.makeUser()
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
    
    func makeUser(){
        let userID:String = (Auth.auth().currentUser?.uid)!
        print(userID)
        
        let key = refUsers.child("User").child(userID).key
        
        let user = ["id":key,
                    "username": usernameTextField.text! as String,
                    "name": nameTextField.text! as String,
                    "email": emailTextField.text! as String ]
        refUsers.child(key).setValue(user)
    }
    
    @IBAction func tapout(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

}
