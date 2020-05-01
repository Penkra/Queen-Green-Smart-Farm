//
//  BasicCell.swift
//  Queen Green Smart Farm
//
//  Created by Emmanuel Gyekye Atta-Penkra on 4/24/20.
//  Copyright © 2020 Special  Topics. All rights reserved.
//

import UIKit

class BasicCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var action: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
