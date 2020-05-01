//
//  IndividualViewController.swift
//  Queen Green Smart Farm
//
//  Created by Emmanuel Gyekye Atta-Penkra on 5/1/20.
//  Copyright © 2020 Special  Topics. All rights reserved.
//

import UIKit

class IndividualViewController: UITableViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var finishBtn: UIBarButtonItem!
    
    var edit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if edit {
            title = "Edit Profile"
            name.text = Actions.getInfo(key: "account_name") as? String ?? ""
            phone.text = Actions.getInfo(key: "account_phone") as? String ?? ""
            email.text = Actions.getInfo(key: "account_email") as? String ?? ""
            location.text = Actions.getInfo(key: "account_neighborhood") as? String ?? ""
        }
    }
    
    @IBAction func finishRegistration(_ sender: UIBarButtonItem) {
        if !edit {
            Actions.showAlert(self, style: .alert, title: "Confirm that you're done", message: "By clicking confirm, you agree to the Terms and Policy of Queen Green Smart Farm.", actions: [UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                self.saveInfo()
            }), Actions.cancelAlertBtn()])
        }else {
            self.saveInfo()
        }
    }
    
    func saveInfo(){
        Actions.saveInfo(key: "account_name", value: self.name.text!)
        Actions.saveInfo(key: "account_phone", value: self.phone.text!)
        Actions.saveInfo(key: "account_email", value: self.email.text!)
        Actions.saveInfo(key: "account_neighborhood", value: self.location.text!)
        Actions.saveInfo(key: "isNotSaved", value: false)
        if edit {
            self.navigationController?.popViewController(animated: true)
        }else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension IndividualViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case name: phone.becomeFirstResponder()
        case phone: email.becomeFirstResponder()
        case email: location.becomeFirstResponder()
        case location: finishRegistration(finishBtn)
        default: break
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case phone: if textField.text == "" {
            textField.text = "+1 "
        }
        default: break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case phone:
            guard let text = textField.text else { break }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = Actions.formattedNumber(number: newString)
            return false
        default: break
        }
        return true
    }
}
