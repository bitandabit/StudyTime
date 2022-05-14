//
//  AddBuddyVC.swift
//  
//
//  Created by Caleb Arendse on 9/29/17.
//  Copyright © 2017 Caleb Arendse. All rights reserved.

import UIKit
import Firebase

class AddBuddyVC: UITableViewController {
    let lists = [["📝Homework", "📄Tests","📒Upcoming"],["🕵️‍♀️🕵️ Buddy Search", "📎Contacts","👫My Friends"], ["⚙️Account Settings", "🔐Sign Out"]]
    let sections = ["Agenda","Find Friends","Settings"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = lists[indexPath.section][indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0 && indexPath.section == 1){
            self.performSegue(withIdentifier: "buddyPass", sender: (Any).self)
        }
        
        if(indexPath.row == 1 && indexPath.section == 2){
            if Auth.auth().currentUser != nil {
                do {
                    try Auth.auth().signOut()
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVCS")
                    present(vc, animated: true, completion: nil)
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
}
