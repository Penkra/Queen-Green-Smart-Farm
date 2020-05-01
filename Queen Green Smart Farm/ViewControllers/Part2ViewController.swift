//
//  Part2ViewController.swift
//  Queen Green Smart Farm
//
//  Created by Emmanuel Gyekye Atta-Penkra on 4/10/20.
//  Copyright © 2020 Special  Topics. All rights reserved.
//

import UIKit

class Part2ViewController: UITableViewController {

    @IBOutlet weak var levelBtn: UIButton!
    @IBOutlet weak var neighborNo: UITextField!
    @IBOutlet weak var childrenNo: UITextField!
    @IBOutlet weak var adultsNo: UITextField!
    @IBOutlet weak var elderlyNo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func chooseLevel(_ sender: UIButton) {
        Actions.showAlert(self, style: .actionSheet, title: "", message: "Garden Use/Level of Participation", actions: [
            UIAlertAction(title: "Food Promotion Wellness Site", style: .default, handler: { _ in
                self.levelBtn.setTitle("Food Promotion Wellness Site", for: .normal)
                Actions.saveInfo(key: "account_level", value: "Food Promotion Wellness Site")
            }),
            UIAlertAction(title: "Produce Sells at Roadside Market", style: .default, handler: { _ in
                self.levelBtn.setTitle("Produce Sells at Roadside Market", for: .normal)
                Actions.saveInfo(key: "account_level", value: "Produce Sells at Roadside Market")
            }),
            UIAlertAction(title: "Produce Sells at Farmer’s Market", style: .default, handler: { _ in
                self.levelBtn.setTitle("Produce Sells at Farmer’s Market", for: .normal)
                Actions.saveInfo(key: "account_level", value: "Produce Sells at Farmer’s Market")
            }),
            UIAlertAction(title: "Food Hub/Distributor", style: .default, handler: { _ in
                self.levelBtn.setTitle("Food Hub/Distributor", for: .normal)
                Actions.saveInfo(key: "account_level", value: "Food Hub/Distributor")
            }),
            UIAlertAction(title: "Other", style: .default, handler: { _ in
                self.levelBtn.setTitle("Other", for: .normal)
                Actions.saveInfo(key: "account_level", value: "Other")
            }),
            Actions.cancelAlertBtn()])
    }
    
    override func prepareForInterfaceBuilder() {
        Actions.saveInfo(key: "account_neighborhoodNo", value: neighborNo.text!)
        Actions.saveInfo(key: "account_childrenNo", value: childrenNo.text!)
        Actions.saveInfo(key: "account_adultsNo", value: adultsNo.text!)
        Actions.saveInfo(key: "account_elderlyNo", value: elderlyNo.text!)
    }
}

extension Part2ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case neighborNo: childrenNo.becomeFirstResponder()
        case childrenNo: adultsNo.becomeFirstResponder()
        case adultsNo: elderlyNo.becomeFirstResponder()
        case elderlyNo: performSegue(withIdentifier: "toPart3", sender: self)
        default: break
        }
        return true
    }
}
