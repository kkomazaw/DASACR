//
//  CDAIViewController.swift
//  DASACR
//
//  Created by Matsui Keiji on 2019/06/23.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import PDFKit
import CoreData

class CDAIViewController: UIViewController {
    
    let appName:AppName = .cdai
    
    @IBOutlet var pdfView:PDFView!
    @IBOutlet var myToolBar:UIToolbar!
    @IBOutlet var Tender:UITextField!
    @IBOutlet var Swollen:UITextField!
    @IBOutlet var PVAS:UITextField!
    @IBOutlet var EVAS:UITextField!
    @IBOutlet var CRP:UITextField!
    @IBOutlet var CDAILabel:UILabel!
    @IBOutlet var CDAISmallLabel:UILabel!
    @IBOutlet var pointLabel:UILabel!
    @IBOutlet var gradeLabel:UILabel!
    @IBOutlet var highValue:UILabel!
    @IBOutlet var moderateValue:UILabel!
    @IBOutlet var lowValue:UILabel!
    @IBOutlet var remissionValue:UILabel!
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
        if let documentURL = Bundle.main.url(forResource: "DASimage", withExtension: "pdf") {
            if let document = PDFDocument(url: documentURL) {
                pdfView.document = document
                pdfView.displayMode = .singlePage
                pdfView.autoScales = true
            }//if let document = PDFDocument
        }//if let documentURL = Bundle.main.url
        Tender.becomeFirstResponder()
    }//override func viewDidLoad()
    
    func calc() {
        let vTender = Double(Tender.text!) ?? 0.0
        let vSwollen = Double(Swollen.text!) ?? 0.0
        let vPVAS = Double(PVAS.text!) ?? 0.0
        let vEVAS = Double(EVAS.text!) ?? 0.0
        let vCRP = Double(CRP.text!) ?? 0.0
        var vDAI = 0.0
        if CRP.text!.isEmpty {
            CDAILabel.text = "CDAI"
            CDAISmallLabel.text = "CDAI"
            highValue.text = ">22"
            moderateValue.text = "10~22"
            lowValue.text = "<10"
            remissionValue.text = "<2.8"
            vDAI = vTender + vSwollen + vPVAS + vEVAS
            if vDAI > 22.0 {
                gradeLabel.text = "High"
            }
            if vDAI >= 10.0 && vDAI <= 22.0 {
                gradeLabel.text = "Moderate"
            }
            if vDAI >= 2.8 && vDAI < 10.0 {
                gradeLabel.text = "Low"
            }
            if vDAI < 2.8 {
                gradeLabel.text = "Remission"
            }
        }//if CRP.text!.isEmpty
        else {
            CDAILabel.text = "SDAI"
            CDAISmallLabel.text = "SDAI"
            highValue.text = ">26"
            moderateValue.text = "11~26"
            lowValue.text = "<11"
            remissionValue.text = "<3.3"
            vDAI = vTender + vSwollen + vPVAS + vEVAS + vCRP
            if vDAI > 26.0 {
                gradeLabel.text = "High"
            }
            if vDAI >= 11.0 && vDAI <= 26.0 {
                gradeLabel.text = "Moderate"
            }
            if vDAI >= 3.3 && vDAI < 11.0 {
                gradeLabel.text = "Low"
            }
            if vDAI < 3.3 {
                gradeLabel.text = "Remission"
            }
        }//else
        if floor(vDAI) - vDAI == 0.0 {
            pointLabel.text = String(Int(vDAI))
        }
        else if floor(vDAI * 10.0) - vDAI * 10.0 == 0.0 {
            pointLabel.text = String(format: "%.1f", vDAI)
        }
        else {
            pointLabel.text = String(format: "%.2f", vDAI)
        }
        saveString = "\(CDAILabel.text!) \(pointLabel.text!)"
        detailString = "Tender Joints \(Tender.text!)\n"
        detailString += "Swollen Joints \(Swollen.text!)\n"
        detailString += "PVAS \(PVAS.text!)\n"
        detailString += "EVAS \(EVAS.text!)\n"
        if !CRP.text!.isEmpty {
            detailString += "CRP \(CRP.text!)\n\n"
        }
        else {
            detailString += "\n"
        }
        detailString += "\(CDAILabel.text!) \(pointLabel.text!) \(gradeLabel.text!)"
    }//func calc()
    
    @IBAction func myActionRUN() {
        view.endEditing(true)
        calc()
    }//@IBAction func myActionRUN()
    
    @IBAction func myActionDecimal() {
        if CRP.isEditing{
            if Double(CRP.text!) == nil{
                CRP.text = "0."
            }
            if CRP.text!.range(of: ".") == nil{
                CRP.text?.append(".")
            }
        }//if CRP.isEditing
        if PVAS.isEditing{
            if Double(PVAS.text!) == nil{
                PVAS.text = "0."
            }
            if PVAS.text!.range(of: ".") == nil{
                PVAS.text?.append(".")
            }
        }//if PVAS.isEditing
        if EVAS.isEditing{
            if Double(EVAS.text!) == nil{
                EVAS.text = "0."
            }
            if EVAS.text!.range(of: ".") == nil{
                EVAS.text?.append(".")
            }
        }//if EVAS.isEditing
    }//@IBAction func myActionDecimal()
    
    @IBAction func myActionClear() {
        Tender.text = ""
        Swollen.text = ""
        PVAS.text = ""
        EVAS.text = ""
        CRP.text = ""
        pointLabel.text = "0"
        gradeLabel.text = "Remission"
        CDAILabel.text = "CDAI"
        CDAISmallLabel.text = "CDAI"
        highValue.text = ">22"
        moderateValue.text = "10~22"
        lowValue.text = "<10"
        remissionValue.text = "<2.8"
        calc()
        Tender.becomeFirstResponder()
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

}//class CDAIViewController: UIViewController
