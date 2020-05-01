//
//  CalendarViewController.swift
//  Queen Green Smart Farm
//
//  Created by Emmanuel Gyekye Atta-Penkra on 5/1/20.
//  Copyright © 2020 Special  Topics. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarViewController: UITableViewController {

    var crop: Crop?
    var beg_date: Date?
    var end_date: Date?
    
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var to: UILabel!
    
    @IBOutlet weak var calendar_s: FSCalendar!
    @IBOutlet weak var calendar_e: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = crop?.name
        for d in calendar_e.selectedDates {
            calendar_e.deselect(d)
        }
    }
}

extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        for d in calendar_e.selectedDates {
            calendar_e.deselect(d)
        }
        
        beg_date = Calendar.current.date(byAdding: .day, value: crop!.beg_days, to: date)
        end_date = Calendar.current.date(byAdding: .day, value: crop!.end_days, to: date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, YYYY"
        from.text = "From \(formatter.string(from: beg_date!)) (\(crop!.beg_days) days)"
        to.text = "To \(formatter.string(from: end_date!)) (\(crop!.end_days) days)"
        
        let current = beg_date!
        let last = crop!.end_days - crop!.beg_days
        for i in stride(from: last, through: 0, by: -1) {
            calendar_e.select(Calendar.current.date(byAdding: .day, value: i, to: current)!)
        }
    }
}
