//
//  StarterViewController.swift
//  Queen Green Smart Farm
//
//  Created by Emmanuel Gyekye Atta-Penkra on 5/1/20.
//  Copyright © 2020 Special  Topics. All rights reserved.
//

import UIKit

class StarterViewController: UITableViewController {

    @IBOutlet weak var individualStack: UIStackView!
    @IBOutlet weak var neighborhoodStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        individualStack.isUserInteractionEnabled = true
        neighborhoodStack.isUserInteractionEnabled = true
        
        individualStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(isIndividual)))
        neighborhoodStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(isNeighborhood)))
    }
    
    @objc func isIndividual(){
        Actions.saveInfo(key: "account_type", value: "Individual")
        performSegue(withIdentifier: "individual", sender: nil)
    }
    
    @objc func isNeighborhood(){
        Actions.saveInfo(key: "account_type", value: "Neighborhood")
        performSegue(withIdentifier: "part1", sender: nil)
    }
}
