////
//  BuddyViewController.swift
//  Study Time
//
//  Created by Caleb Arendse on 9/27/17.
//  Copyright © 2017 Caleb Arendse. All rights reserved.
//

import UIKit
import Firebase

class BuddyViewController : UITableViewController{
    @IBOutlet weak var searchTextBox: UITextField!
    @IBOutlet weak var searchbar: UISearchBar!
    var userList = [String]()
    var search = 0
    
    let searchController = UISearchController(searchResultsController: nil) //By setting the controller to nil we load the results on the same view that we are searching
    @IBOutlet weak var tablev: UITableView!
    var usrsRef : DatabaseReference!
    var frdRef: DatabaseReference!
    
    override func viewDidLoad() {
        usrsRef = Database.database().reference().child("Users");
        frdRef = Database.database().reference().child("Buddys");
        
        super.viewDidLoad()
        UISearchBar.appearance().barTintColor = UIColor(
            red:187,
            green:71,
            blue:68,
            alpha:1)
        tableView.separatorStyle = .none
        findFriend()
        // Do any additional setup after loading the view.
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation  = false
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
    }
    
    func searchBarIsEmpty() -> Bool{
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func findFriend() {
        usrsRef.queryOrdered(byChild:"username").queryEqual(toValue:searchController.searchBar.text).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            
            for snap in snapshot.children {
                let userSnap = snap as! DataSnapshot
                let userDict = userSnap.value as! [String:AnyObject]
                let unm = userDict["username"] as! String
                self.userList = [String]() // Should Reset array back to nil
                self.userList.append(unm)
                self.search = 1
                print("username = \(self.userList)")
                self.tableView.reloadData()
            }
            
        })
    }
    
   
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return userList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
        cell.textLabel?.text = userList[indexPath.row]
        if(search == 1){
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        return cell
    }
    
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   let bud = userList
   print(bud)
    if(search == 1){
    makeFrd()
    }
    tableView.deselectRow(at: indexPath, animated: true)
 }
    func makeFrd(){
 usrsRef.queryOrdered(byChild:"username").queryEqual(toValue:searchController.searchBar.text).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            for snap in snapshot.children {
                let userSnap = snap as! DataSnapshot
                let userDict = userSnap.value as! [String:AnyObject]
                let bud = userDict["username"] as! String
                
                let userID:String = (Auth.auth().currentUser?.uid)!
                let key = self.frdRef.child("Buddys").child(userID).key
                let frd = ["id":key,
                            "username" : bud as String,]
                self.frdRef.child(key).setValue(frd)
            }
        })
        
        
    }
    
    
    
}

extension BuddyViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        findFriend()
        self.userList = [String]() // Should Reset array back to nil
        if(searchController.searchBar.text! != nil && search == 0){
        self.userList.append(searchController.searchBar.text!)
        }
        tableView.reloadData()
    }
}
