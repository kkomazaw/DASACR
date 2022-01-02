//
//  SaveViewController.swift
//  DASACR
//
//  Created by Matsui Keiji on 2019/06/23.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

class SaveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet var tableView:UITableView!
    
    var savedArray = [DASData]()
    var unfilteredRows = [String]()
    var filteredRows = [String]()
    let searchController = UISearchController(searchResultsController: nil)
    var myText = ""
    var myDetailText = ""
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "search"
        tableView.tableHeaderView = searchController.searchBar
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale.current)
        super.viewDidLoad()
        myCalc()
        navigationItem.rightBarButtonItem = editButtonItem
    }//override func viewDidLoad()
    
    func myCalc(){
        myCalc2()
        filteredRows = unfilteredRows
    }//func myCalc()
    
    func myCalc2(){
        unfilteredRows.removeAll()
        do{
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
            let fetchRequest: NSFetchRequest<DASData> = DASData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K = %@", "title", myText)
            fetchRequest.sortDescriptors = [sortDescriptor]
            savedArray = try myContext.fetch(fetchRequest)
        }
        catch{
            print("Fetching Failed.")
        }
        if savedArray.count == 0 {
            return
        }
        for i in 0 ..< savedArray.count{
            let myDate = dateFormatter.string(from: savedArray[i].date!)
            unfilteredRows.append(myDate + " " + savedArray[i].memo! + " " +  savedArray[i].value!)
        }//for i in 0 ..< savedArray.count
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }//func myCalc2()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SaveCell", for: indexPath)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel!.text = filteredRows[indexPath.row]
        cell.textLabel?.minimumScaleFactor = 0.5
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredRows = unfilteredRows.filter {$0.lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredRows = unfilteredRows
        }
        tableView.reloadData()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        if(editing && !tableView.isEditing){
            tableView.setEditing(true, animated: true)
            navigationItem.rightBarButtonItem?.title = NSLocalizedString("savedone", comment: "")
        }else{
            tableView.setEditing(false, animated: true)
            navigationItem.rightBarButtonItem?.title = NSLocalizedString("saveedit", comment: "")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let indexOfSelectedRow = unfilteredRows.firstIndex(of: filteredRows[indexPath.row])
            myContext.delete(savedArray[indexOfSelectedRow!])
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            unfilteredRows.remove(at: indexOfSelectedRow!)
            filteredRows.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            myCalc2()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexOfSelectedRow = unfilteredRows.firstIndex(of: filteredRows[indexPath.row])
        myDetailText = "\(filteredRows[indexPath.row])\n\n\(savedArray[indexOfSelectedRow!].detailValue!)"
        performSegue(withIdentifier: "toSaveDetail", sender: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let toSaveDetail = segue.destination as! SaveDetailViewController
        toSaveDetail.myDetailText = myDetailText
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
}//class SaveViewController: UIViewController
