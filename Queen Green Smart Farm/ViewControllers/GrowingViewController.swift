//
//  GrowingViewController.swift
//  Queen Green Smart Farm
//
//  Created by Emmanuel Gyekye Atta-Penkra on 4/24/20.
//  Copyright © 2020 Special  Topics. All rights reserved.
//

import UIKit

class GrowingViewController: UITableViewController {
    
    let internet = Internet()
    var cropGroups = [CropGroup]()
    var crop: Crop?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        internet.reqResponse = self
        internet.request(url: DOMAIN + "fetch-crops", method: "POST", parameters: [:], identifier: 0)
        
        tableView.register(UINib(nibName: "BasicCell", bundle: nil), forCellReuseIdentifier: "BasicCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Actions.getInfo(key: "isNotSaved") as? Bool ?? true {
            performSegue(withIdentifier: "startup", sender: self)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cropGroups.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cropGroups[section].crops.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath) as! BasicCell
        let x = cropGroups[indexPath.section].crops[indexPath.row]
        cell.action.isHidden = true
        cell.name.text = x.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var alertActions = [UIAlertAction]()
        crop = cropGroups[indexPath.section].crops[indexPath.row]
        if crop!.season == 0 || crop!.season == 1 {
            alertActions.append(UIAlertAction(title: "Spring/Summer", style: .default, handler: { _ in
                self.selectSeason(1)
            }))
        }
        if crop!.season == 0 || crop!.season == 2 {
            alertActions.append(UIAlertAction(title: "Fall/Winter", style: .default, handler: { _ in
                self.selectSeason(2)
            }))
        }
        alertActions.append(Actions.cancelAlertBtn())
        Actions.showAlert(self, style: .actionSheet, title: "", message: "Choose Season", actions: alertActions)
    }
    
    func selectSeason(_ season: Int){
        crop!.season = season
        performSegue(withIdentifier: "calendar", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case is CalendarViewController:
            let c = segue.destination as! CalendarViewController
            c.crop = crop
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cropGroups[section].bed
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
//        header.contentView.backgroundColor = UIColor.gray
        header.textLabel?.textColor = .blue
    }
}

extension GrowingViewController: Response {
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
                    guard let all_crops = json["all_crops"] as? [Any] else { return }
                    for cropGroup in all_crops {
                        guard let cropGroup = cropGroup as? [String: Any] else { return }
                        var crops = [Crop]()
                        guard let _crops = cropGroup["crops"] as? [Any] else { return }
                        for _crop in _crops {
                            guard let _crop = _crop as? [String: Any] else { return }
                            crops.append(Crop(id: _crop["id"] as! Int, name: _crop["name"] as! String, season: _crop["season"] as! Int, beg_days: _crop["beg_days"] as! Int, end_days: _crop["end_days"] as! Int))
                        }
                        cropGroups.append(CropGroup(bed: cropGroup["bed"] as! String, crops: crops))
                    }
                    tableView.reloadData()
                default: break
                }
            }
        }catch {
            print("Something happened with identifier: \(identifier)")
        }
    }
    
    func getError(err: String, msg: String, identifier: Int) {
        let alert = UIAlertController(title: err, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Default action"), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
