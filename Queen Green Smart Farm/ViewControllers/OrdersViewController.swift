//
//  OrdersViewController.swift
//  Queen Green Smart Farm
//
//  Created by Emmanuel Gyekye Atta-Penkra on 4/24/20.
//  Copyright © 2020 Special  Topics. All rights reserved.
//

import UIKit

class OrdersViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.setEmptyMessage("You haven't made any orders yet.")
    }
    
    @IBAction func makeOrder(_ sender: Any) {
//        Actions.showAlert(self, style: .alert, title: "User will be able to make an order from here in the next update", message: "", actions: [UIAlertAction(title: "Okay", style: .default, handler: nil)])
        openURL("https://thehouseofj.net/shop-wellness/ols/categories/queen-green-farm")
    }
}
