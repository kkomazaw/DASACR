//
//  DasViewController.swift
//  DASACR
//
//  Created by Matsui Keiji on 2019/06/23.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import PDFKit
import CoreData

class DasViewController: UIViewController {
    
    let appName:AppName = .das
    
    @IBOutlet var pdfView:PDFView!
    @IBOutlet var myToolBar:UIToolbar!
    @IBOutlet var Tender:UITextField!
    @IBOutlet var Swollen:UITextField!
    @IBOutlet var VAS:UITextField!
    @IBOutlet var CRPorESR:UISegmentedControl!
    @IBOutlet var CRP:UITextField!
    @IBOutlet var DAS28CRPLabel:UILabel!
    @IBOutlet var DAS28SmallLabel:UILabel!
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
        let vVAS = Double(VAS.text!) ?? 0.0
        let vCRP = Double(CRP.text!) ?? 0.0
        let vCRPorESR = CRPorESR.selectedSegmentIndex
        var vDAS = 0.0
        switch vCRPorESR {
        case 0:
            vDAS = 0.555 * sqrt(vTender) + 0.284 * sqrt(vSwollen) + 0.36 * log(vCRP * 10.0 + 1.0) + 0.0142 * vVAS + 0.96
            vDAS = 0.01 * round(vDAS * 100.0)
            if vDAS > 4.1 {
                gradeLabel.text = "High"
            }
            if vDAS >= 2.7 && vDAS <= 4.1 {
                gradeLabel.text = "Moderate"
            }
            if vDAS >= 2.3 && vDAS < 2.7 {
                gradeLabel.text = "Low"
            }
            if vDAS < 2.3 {
                gradeLabel.text = "Remission"
            }
            DAS28CRPLabel.text = "DAS28CRP"
            DAS28SmallLabel.text = "DAS28CRP"
            highValue.text = ">4.1"
            moderateValue.text = "2.7~4.1"
            lowValue.text = "<2.7"
            remissionValue.text = "<2.3"
        case 1:
            vDAS = 0.555 * sqrt(vTender) + 0.284 * sqrt(vSwollen) + 0.7 * log(vCRP) + 0.0142 * vVAS
            vDAS = 0.01 * round(vDAS * 100.0)
            if vDAS > 5.1 {
                gradeLabel.text = "High"
            }
            if vDAS >= 3.2 && vDAS <= 5.1 {
                gradeLabel.text = "Moderate"
            }
            if vDAS >= 2.6 && vDAS < 3.2 {
                gradeLabel.text = "Low"
            }
            if vDAS < 2.6 {
                gradeLabel.text = "Remission"
            }
            DAS28CRPLabel.text = "DAS28ESR"
            DAS28SmallLabel.text = "DAS28ESR"
            highValue.text = ">5.1"
            moderateValue.text = "3.2~5.1"
            lowValue.text = "<3.2"
            remissionValue.text = "<2.6"
        default:
            break
        }//switch vCRPorESR
        pointLabel.text = String(format: "%.2f", vDAS)
        var CRPorESR = "CRP"
        if DAS28CRPLabel.text! == "DAS28ESR" {
            CRPorESR = "ESR"
        }
        saveString = "\(pointLabel.text!)(\(CRPorESR))"
        detailString = DAS28CRPLabel.text! + "\n\n"
        detailString += "Tender Joints \(Tender.text!)\n"
        detailString += "Swollen Joints \(Swollen.text!)\n"
        detailString += "VAS \(VAS.text!)\n"
        if vCRPorESR == 0 {
            detailString += "CRP \(CRP.text!)\n\n"
        }
        else {
            detailString += "ESR \(CRP.text!)\n\n"
        }
        detailString += "\(DAS28CRPLabel.text!) \(pointLabel.text!) \(gradeLabel.text!)"
    }//func calc()
    
    @IBAction func myActionRUN() {
        view.endEditing(true)
        calc()
    }//@IBAction func myActionRUN()
    
    @IBAction func segmentChanged() {
        calc()
    }
    
    @IBAction func myActionDecimal() {
        if CRP.isEditing{
            if Double(CRP.text!) == nil{
                CRP.text = "0."
            }
            if CRP.text!.range(of: ".") == nil{
                CRP.text?.append(".")
            }
        }//if CRP.isEditing
    }//@IBAction func myActionDecimal()
    
    @IBAction func myActionClear() {
        Tender.text = ""
        Swollen.text = ""
        VAS.text = ""
        CRPorESR.selectedSegmentIndex = 0
        CRP.text = ""
        pointLabel.text = "0"
        gradeLabel.text = "Remission"
        DAS28CRPLabel.text = "DAS28CRP"
        DAS28SmallLabel.text = "DAS28CRP"
        highValue.text = ">4.1"
        moderateValue.text = "2.7~4.1"
        lowValue.text = "<2.7"
        remissionValue.text = "<2.3"
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

}//class DasViewController: UIViewController
