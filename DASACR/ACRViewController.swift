//
//  ACRViewController.swift
//  DASACR
//
//  Created by Matsui Keiji on 2019/06/23.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

class ACRViewController: UIViewController {
    
    let appName:AppName = .acr
    
    @IBOutlet var myToolBar:UIToolbar!
    @IBOutlet var Joint:UISegmentedControl!
    @IBOutlet var Serology:UISegmentedControl!
    @IBOutlet var AcutePhase:UISegmentedControl!
    @IBOutlet var Duration:UISegmentedControl!
    @IBOutlet var pointLabel:UILabel!
    @IBOutlet var judgeLabel:UILabel!
    @IBOutlet var SavedButton:UIBarButtonItem!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //saveStringはSaveViewControllerのtableで表示される
    //detailStringはSaveDetailViewControllerのtextViewで表示される
    var saveString = ""
    var detailString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        SavedButton.title = NSLocalizedString("Saved", comment: "")
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        if height > 800.0 && height < 1000.0 {
            myToolBar.frame = CGRect(x: 0, y: height * 0.92, width: width, height: height * 0.055)
        }
        if height > 1000.0 {
            myToolBar.frame = CGRect(x: 0, y: height * 0.94, width: width, height: height * 0.05)
        }
        calc()
    }//override func viewDidLoad()
    
    func calc() {
        var vJoint = Joint.selectedSegmentIndex
        if vJoint == 4 {
            vJoint = 5
        }
        var vSerology = 0
        switch Serology.selectedSegmentIndex {
        case 0:
            vSerology = 0
        case 1:
            vSerology = 2
        case 2:
            vSerology = 3
        default:
            break
        }//switch Serology.selectedSegmentIndex
        let vAcutePhase = AcutePhase.selectedSegmentIndex
        let vDuration = Duration.selectedSegmentIndex
        let vPoint = vJoint + vSerology + vAcutePhase + vDuration
        if vPoint >= 6 {
            judgeLabel.text = "Definite RA"
        }
        else {
            judgeLabel.text = ""
        }
        pointLabel.text = "\(vPoint)"
        saveString = pointLabel.text!
        if vPoint >= 6 {
            saveString += " RA"
        }
        detailString = "A. Joint involvement\n"
        detailString += "(L: Large joints, S: Small joints)\n"
        switch Joint.selectedSegmentIndex {
        case 0:
            detailString += "1L\n\n"
        case 1:
            detailString += "2-10L\n\n"
        case 2:
            detailString += "1-3S\n\n"
        case 3:
            detailString += "4-10S\n\n"
        case 4:
            detailString += ">10\n\n"
        default:
            break
        }//switch Joint.selectedSegmentIndex
        detailString += "B. Serology\n"
        detailString += "-: negative, +: Low-positive, ++: High-positive\n"
        switch Serology.selectedSegmentIndex {
        case 0:
            detailString += "RF- & ACPA-\n\n"
        case 1:
            detailString += "RF+ or ACPA+\n\n"
        case 2:
            detailString += "RF++ or ACPA++\n\n"
        default:
            break
        }//switch Serology.selectedSegmentIndex
        detailString += "C. Acute-phase reactants\n"
        if AcutePhase.selectedSegmentIndex == 0 {
            detailString += "Normal CRP & ESR\n\n"
        }
        else {
            detailString += "Abnormal CRP or ESR\n\n"
        }
        detailString += "D. Duration of symtoms\n"
        if Duration.selectedSegmentIndex == 0 {
            detailString += "<6 weeks\n\n"
        }
        else {
            detailString += "≥6 weeks\n\n"
        }
        detailString += "Score \(vPoint)/10 \(judgeLabel.text!)"
    }//func calc()
    
    @IBAction func selectorChanged() {
        calc()
    }
    
    @IBAction func myActionClear() {
        Joint.selectedSegmentIndex = 0
        Serology.selectedSegmentIndex = 0
        AcutePhase.selectedSegmentIndex = 0
        Duration.selectedSegmentIndex = 0
        pointLabel.text = "0"
        judgeLabel.text = ""
        calc()
    }//@IBAction func myActionClear()
    
    @IBAction func myActionSave(){
        let titleString = NSLocalizedString("note", comment: "")
        let messageString = NSLocalizedString("annotations", comment: "")
        let okTitle = NSLocalizedString("done", comment: "")
        let cancelTitle = NSLocalizedString("cancel", comment: "")
        let alert = UIAlertController(title:titleString, message: messageString, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: okTitle, style: UIAlertAction.Style.default, handler:{(action:UIAlertAction!) -> Void in
            let textField = alert.textFields![0]
            let dasData = DASData(context: self.myContext)
            dasData.title = self.appName.rawValue
            dasData.date = Date()
            dasData.memo = textField.text
            dasData.value = self.saveString
            dasData.detailValue = self.detailString
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            let id = self.appName.rawValue + "Save"
            self.performSegue(withIdentifier: id, sender: true)
        })//let okAction = UIAlertAction
        let cancelAction = UIAlertAction(title: cancelTitle, style: UIAlertAction.Style.cancel, handler:{(action:UIAlertAction!) -> Void in
        })//let cancelAction = UIAlertAction
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        // UIAlertControllerにtextFieldを追加
        alert.addTextField { (textField:UITextField!) -> Void in }
        self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }//@IBAction func myActionSave()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sendText = segue.destination as! SaveViewController
        sendText.myText = appName.rawValue
    }//override func prepare(for segue
    
}//class ACRViewController: UIViewController
