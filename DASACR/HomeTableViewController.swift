//
//  HomeTableViewController.swift
//  DASACR
//
//  Created by Matsui Keiji on 2019/06/23.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    typealias TitleID = (title: String,id: String)
    var titleArray = [TitleID]()

    override func viewDidLoad() {
        super.viewDidLoad()
        titleArray = [("DAS28","das"),
                      ("CDAI / SDAI","cdai"),
                      ("ACR-EULAR criteria","acr")]
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = titleArray[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: titleArray[indexPath.row].id, sender: true)
    }
    
}//class HomeTableViewController: UITableViewController
