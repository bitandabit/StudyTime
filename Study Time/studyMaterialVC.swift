//
//  studyMaterialVC.swift
//  Study Time
//
//  Created by Caleb Arendse on 10/1/17.
//  Copyright © 2017 Caleb Arendse. All rights reserved.
//

import UIKit

class studyMaterialVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var materialTable: UITableView!
    
    let study = [["Files", "Flashcards", "Web Resources"], ["Milo","Robert","Charl"]] //eventually edit for actual friends (link to database)
    
    let sections = ["My Study Materials", "Friends Study Materials"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return study[section].count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studym", for: indexPath)
        cell.textLabel?.text = study[indexPath.section][indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middleView: UIView!
    
    override func viewDidLoad() {
         materialTable.tableFooterView = UIView()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
