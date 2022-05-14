//
//  friendVC.swift
//  Study Time
//
//  Created by Caleb Arendse on 9/27/17.
//  Copyright © 2017 Caleb Arendse. All rights reserved.
//

import UIKit
import Firebase

class friendVC: UITableViewController {
    @IBOutlet weak var searchTextBox: UITextField!
    @IBOutlet weak var searchbar: UISearchBar!

    let searchController = UISearchController(searchResultsController: nil) //By setting the controller to nil we load the results on the same view that we are searching
    @IBOutlet weak var tablev: UITableView!
    var usrsRef : DatabaseReference!
    
    override func viewDidLoad() {
        usrsRef = Database.database().reference().child("Users");
        super.viewDidLoad()
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
           // var userList = [String]()
            let unm = userDict["username"] as! String
           // userList.append(unm)
            print("username = \(unm)")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension friendVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        findFriend()
    }
}
