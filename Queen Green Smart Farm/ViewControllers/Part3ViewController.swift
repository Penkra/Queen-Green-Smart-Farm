//
//  Part3ViewController.swift
//  Queen Green Smart Farm
//
//  Created by Emmanuel Gyekye Atta-Penkra on 4/10/20.
//  Copyright © 2020 Special  Topics. All rights reserved.
//

import UIKit

class Part3ViewController: UITableViewController {

    @IBOutlet weak var owner: UITextField!
    @IBOutlet weak var waterSupplyBtn: UIButton!
    @IBOutlet weak var relationshipBtn: UIButton!
    @IBOutlet weak var authorizationSegment: UISegmentedControl!
    
    @IBOutlet weak var spaceLength: UITextField!
    @IBOutlet weak var spaceWidth: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        
        let font = UIFont.systemFont(ofSize: 17)
    authorizationSegment.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
    }

    @IBAction func selectWaterSupply(_ sender: UIButton) {
        Actions.showAlert(self, style: .actionSheet, title: "", message: "Choose An Option", actions: [
            UIAlertAction(title: "Irrigation", style: .default, handler: { _ in
                self.waterSupplyBtn.setTitle("Irrigation", for: .normal)
                Actions.saveInfo(key: "account_landWaterSupply", value: "Irrigation")
            }),
            UIAlertAction(title: "Hose", style: .default, handler: { _ in
                self.waterSupplyBtn.setTitle("Hose", for: .normal)
                Actions.saveInfo(key: "account_landWaterSupply", value: "Hose")
            }),
            UIAlertAction(title: "Watering Can (Not Recommended)", style: .default, handler: { _ in
                self.waterSupplyBtn.setTitle("Watering Can", for: .normal)
                Actions.saveInfo(key: "account_landWaterSupply", value: "Watering Can")
            }),
            UIAlertAction(title: "Sprinkler", style: .default, handler: { _ in
                self.waterSupplyBtn.setTitle("Sprinkler", for: .normal)
                Actions.saveInfo(key: "account_landWaterSupply", value: "Sprinkler")
            }),
            UIAlertAction(title: "Other", style: .default, handler: { _ in
                self.waterSupplyBtn.setTitle("Other", for: .normal)
                Actions.saveInfo(key: "account_landWaterSupply", value: "Other")
            }),
            Actions.cancelAlertBtn()])
    }
    
    @IBAction func chooseRelationship(_ sender: UIButton) {
        Actions.showAlert(self, style: .actionSheet, title: "", message: "Choose Relationship", actions: [
            UIAlertAction(title: "Self", style: .default, handler: { _ in
                self.relationshipBtn.setTitle("Owned by Self", for: .normal)
                Actions.saveInfo(key: "account_landOwnerRelationship", value: "Self")
            }),
            UIAlertAction(title: "Friend", style: .default, handler: { _ in
                self.relationshipBtn.setTitle("Owned by Friend", for: .normal)
                Actions.saveInfo(key: "account_landOwnerRelationship", value: "Friend")
            }),
            UIAlertAction(title: "Relative", style: .default, handler: { _ in
                self.relationshipBtn.setTitle("Owned by Relative", for: .normal)
                Actions.saveInfo(key: "account_landOwnerRelationship", value: "Relative")
            }),
            UIAlertAction(title: "Partner", style: .default, handler: { _ in
                self.relationshipBtn.setTitle("Owned by Partner", for: .normal)
                Actions.saveInfo(key: "account_landOwnerRelationship", value: "Partner")
            }),
            Actions.cancelAlertBtn()])
    }
    
    @IBAction func finish(_ sender: UIButton) {
        Actions.showAlert(self, style: .alert, title: "Confirm that you're done", message: "By clicking confirm, you agree to the Terms and Policy of Queen Green Smart Farm.", actions: [
            UIAlertAction(title: "Confirm", style: .default, handler: { _ in
//            Actions.showAlert(self, style: .alert, title: "We'll finish the app soon", message: "This is the end for the initial submission. Final app will be completed by due date. Thank you", actions: [UIAlertAction(title: "Awesome", style: .default, handler: nil)])
                Actions.saveInfo(key: "account_landOwner", value: self.owner.text!)
                Actions.saveInfo(key: "isNotSaved", value: false)
                self.dismiss(animated: true, completion: nil)
            }),
            Actions.cancelAlertBtn()])
    }
}
