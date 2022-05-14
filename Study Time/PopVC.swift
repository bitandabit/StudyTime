//
//  PopVC.swift
//  Study Time
//
//  Created by Caleb Arendse on 9/23/17.
//  Copyright © 2017 Caleb Arendse. All rights reserved.
//

import UIKit
import Firebase
class PopVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var friendList = [String]()
    var friRef: DatabaseReference!
    
    
    @IBOutlet weak var cell: UITableViewCell!
    
    @IBOutlet weak var budTable: UITableView!
    
    override func viewDidLoad() {
        
        if Auth.auth().currentUser != nil {
        let userID:String = (Auth.auth().currentUser?.uid)!
        friRef = Database.database().reference().child("Buddys").child(userID);
        friRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if !snapshot.exists(){ return }
            let friend = snapshot.childSnapshot(forPath: "username").value as! String
            self.friendList.append(friend)
        })
 
            
        }
        
        budTable.tableFooterView = UIView()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friend", for: indexPath)
        cell.textLabel?.text = friendList[indexPath.row]
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func testBtn(_ sender: Any) {
   self.view.removeFromSuperview()
    }
}
