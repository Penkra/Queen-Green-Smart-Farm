//
//  ProfileViewController.swift
//  Queen Green Smart Farm
//
//  Created by Emmanuel Gyekye Atta-Penkra on 5/1/20.
//  Copyright © 2020 Special  Topics. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {

    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var role: UILabel!
    @IBOutlet weak var neighborhood: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewDidAppear(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Actions.getInfo(key: "isNotSaved") as? Bool ?? true {
            performSegue(withIdentifier: "startup", sender: self)
            return
        }
        type.text = Actions.getInfo(key: "account_type") as? String ?? ""
        name.text = Actions.getInfo(key: "account_name") as? String ?? ""
        phone.text = Actions.getInfo(key: "account_phone") as? String ?? ""
        email.text = Actions.getInfo(key: "account_email") as? String ?? ""
        role.text = Actions.getInfo(key: "account_role") as? String ?? ""
        neighborhood.text = Actions.getInfo(key: "account_neighborhood") as? String ?? ""
    }
    
    @IBAction func settings(_ sender: Any) {
        Actions.showAlert(self, style: .actionSheet, title: "", message: "Settings", actions: [UIAlertAction(title: "Edit Profile", style: .default, handler: { _ in
            self.performSegue(withIdentifier: "register", sender: nil)
        }), Actions.cancelAlertBtn()])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let d = segue.destination as! IndividualViewController
        d.edit = true
    }
}
