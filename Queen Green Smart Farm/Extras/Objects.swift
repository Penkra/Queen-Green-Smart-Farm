//
//  Objects.swift
//  Queen Green Smart Farm
//
//  Created by Emmanuel Gyekye Atta-Penkra on 4/10/20.
//  Copyright © 2020 Special  Topics. All rights reserved.
//

import Foundation

struct MenuItem {
    let id: String
    let icon: String
    let title: String
    let content: String
    let ic_rounded: Bool
}

struct CropGroup {
    let bed: String
    let crops: [Crop]
}

struct Crop {
    let id: Int
    let name: String
    var season: Int
    let beg_days: Int
    let end_days: Int
}
