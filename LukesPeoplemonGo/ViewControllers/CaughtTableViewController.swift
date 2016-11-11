//
//  CaughtTableViewController.swift
//  LukesPeoplemonGo
//
//  Created by Lucas Lell on 11/10/16.
//  Copyright © 2016 Luuke192. All rights reserved.
//

import UIKit

class CaughtTableViewController: UITableViewController {
    
    
    var caught: [Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let person = Person()
        WebServices.shared.getObjects(person) { (objects, error) in
            if let objects = objects{
                self.caught = objects
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return caught.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CaughtTableViewCell.self)) as! CaughtTableViewCell
        let person = caught[indexPath.row]
        cell.setUpCell(person: person)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}
