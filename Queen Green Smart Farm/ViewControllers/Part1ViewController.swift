//
//  Part1ViewController.swift
//  Queen Green Smart Farm
//
//  Created by Emmanuel Gyekye Atta-Penkra on 4/10/20.
//  Copyright © 2020 Special  Topics. All rights reserved.
//

import UIKit

class Part1ViewController: UITableViewController {

    @IBOutlet weak var neighborhood: UIButton!
    @IBOutlet weak var member: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var roleBtn: UIButton!
    
    let menu = MenuLauncher()
    let internet = Internet()
    
    var neighborhoods = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        
        menu.menuProtocol = self
        internet.reqResponse = self
        
        internet.request(url: DOMAIN + "fetch-neighborhoods", method: "POST", parameters: [:], identifier: 0)
    }
    
    @IBAction func openNeighborhoods(_ sender: UIButton) {
        var alertActions = [UIAlertAction]()
        for neighborhood in neighborhoods {
            alertActions.append(UIAlertAction(title: neighborhood, style: .default, handler: { _ in
                self.setNeighborhood(with: neighborhood)
            }))
        }
        alertActions.append(Actions.cancelAlertBtn())
        Actions.showAlert(self, style: .actionSheet, title: "", message: "Choose Neighborhood", actions: alertActions)
    }
    
    func setNeighborhood(with neighborhood: String){
        self.neighborhood.setTitle(neighborhood, for: .normal)
        Actions.saveInfo(key: "account_neighborhood", value: neighborhood)
    }
    
    @IBAction func openRoles(_ sender: UIButton) {
        menu.setUp()
        let shareMenuItems: [MenuItem] = [
            MenuItem(id: "MENU_GROUP_LEAD", icon: "leader", title: "Group Lead/Primary Contact", content: "Primary contact to the House of J Queen Green Team. Manages the neighborhood farm sponsorship as the group administrator. Distributes information to the larger neighborhood group.", ic_rounded: false),
            MenuItem(id: "MENU_RECRUITER", icon: "love", title: "Volunteer Recruiter & Manager", content: "Recruits local volunteers to help with farming/gardening tasks. Manages the assignment and completion of volunteer tasks.", ic_rounded: false),
            MenuItem(id: "MENU_DISTRIBUTOR", icon: "delivery", title: "Food Distributor & Marketing", content: "Connects group to market opportunities for distribution of harvested crops. Promotes food sales to local neighbors.", ic_rounded: false),
            MenuItem(id: "MENU_MAINTENANCE", icon: "construction-worker", title: "Groundskeeper & Maintenance", content: "Leads the fundamental landscape tasks and daily upkeep needed to maintain a farm/garden plot. Responds to maintenance issues.", ic_rounded: false),
            MenuItem(id: "MENU_PURCHASER", icon: "customer", title: "Purchaser/Acquisition", content: "Serves as the point of contact for getting all materials, supplies and equipment needed in setting up, maintaining and transitioning each farm/garden plot.", ic_rounded: false)
        ]
        menu.showMenu(header: "What is your role? 👩🏾‍🌾", menu: shareMenuItems)
    }
}

extension Part1ViewController: Response {
    func getResponse(data: Data, identifier: Int) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let json = json as? [String: Any] {
                if json["_status"] as! Int == 0 {
                    getError(err: json["_error"] as? String ?? "", msg: json["_message"] as? String ?? "", identifier: identifier)
                    return
                }
                switch identifier {
                case 0:
                    guard let neighborhoods = json["neighborhoods"] as? [String] else { return }
                    self.neighborhoods = neighborhoods
                default: break
                }
            }
        }catch {
            print("Something happened with identifier: \(identifier)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        Actions.saveInfo(key: "account_name", value: member.text!)
        Actions.saveInfo(key: "account_phone", value: phone.text!)
        Actions.saveInfo(key: "account_email", value: email.text!)
        Actions.saveInfo(key: "account_role", value: "Group Lead/Primary Contact")
    }
    
    func getError(err: String, msg: String, identifier: Int) {
        let alert = UIAlertController(title: err, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Default action"), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension Part1ViewController: Menu {
    func getMenuItem(id: String) {
        switch id {
        case "MENU_GROUP_LEAD": roleBtn.setTitle("Group Lead/Primary Contact", for: .normal)
//        case "MENU_RECRUITER": roleBtn.setTitle("Volunteer Recruiter & Manager", for: .normal)
//        case "MENU_DISTRIBUTOR": roleBtn.setTitle("Food Distributor & Marketing", for: .normal)
//        case "MENU_MAINTENANCE": roleBtn.setTitle("Groundskeeper & Maintenance", for: .normal)
//        case "MENU_PURCHASER": roleBtn.setTitle("Purchaser/Acquisition", for: .normal)
        default: getError(err: "You cannot sign up for your neighborhood", msg: "Please contact your Group Lead to sign up for your neighborhood", identifier: -1)
        }
    }
}

extension Part1ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case member: phone.becomeFirstResponder()
        case phone: email.becomeFirstResponder()
        case email: resignFirstResponder()
        default: break
        }
        return true
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
