//
//  SaveDetailViewController.swift
//  DASACR
//
//  Created by Matsui Keiji on 2019/06/23.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit

class SaveDetailViewController: UIViewController {
    
    @IBOutlet var myTextView:UITextView!
    @IBOutlet var actionButton:UIBarButtonItem!
    
    var myDetailText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTextView.text = myDetailText
    }//override func viewDidLoad()
    
    @IBAction func actionButtonTapped(){
        let activityItems = [myTextView.text as Any]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }//@IBAction func actionButtonTapped()
    
}//class SaveDetailViewController: UIViewController
