//
//  ViewController.swift
//  Queen Green Smart Farm
//
//  Created by Emmanuel Gyekye Atta-Penkra on 4/9/20.
//  Copyright © 2020 Special  Topics. All rights reserved.
//

import UIKit
import SafariServices

class FirstViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func learnMore(_ sender: UIButton) {
        openURL("https://thehouseofj.net/")
    }
    
    @IBAction func register(_ sender: UIButton) {
        Actions.showAlert(self, style: .alert, title: "Before you begin", message: "Application is only in 3 parts. For your safe of mind 😌, every entry is automatically saved. Awesome right?", actions: [
            UIAlertAction(title: "Let's begin", style: .default, handler: { _ in
                self.performSegue(withIdentifier: "identify", sender: self)
            }),
            Actions.cancelAlertBtn()])
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        Actions.showAlert(self, style: .alert, title: "In the future", message: "Users can sign in with their email, and verify with a temporary code sent to their email", actions: [UIAlertAction(title: "Okay", style: .default, handler: nil)])
    }
    
    @IBAction func needHelp(_ sender: UIButton) {
        Actions.showAlert(self, style: .actionSheet, title: "", message: "FAQs or Contact Us", actions: [
            UIAlertAction(title: "Frequently Asked Questions", style: .default, handler: { _ in
                self.openURL("https://thehouseofj.net/queen-green-farm")
            }),
            UIAlertAction(title: "Reach out to us", style: .default, handler: { _ in
                self.showContactOptions()
            }),
            Actions.cancelAlertBtn()])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

