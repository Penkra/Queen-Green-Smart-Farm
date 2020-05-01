//
//  MenuLauncher.swift
//  SiD Ride
//
//  Created by Emmanuel Gyekye Atta-Penkra on 3/18/20.
//  Copyright © 2020 Students in Demand. All rights reserved.
//

import Foundation
import UIKit

protocol Menu {
    func getMenuItem(id: String)
}

class MenuLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let dimView = UIView()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        if #available(iOS 13.0, *) {
            cv.backgroundColor = UIColor.systemBackground
        } else {
            cv.backgroundColor = UIColor.white
        }
        return cv
    }()
    var cvHeight: CGFloat = 0
    let cellID = "menuCell"
    
    var menu = [MenuItem]()
    
    let rowHeight = 90
    
    var menuProtocol: Menu!
    
    let headerID = "menuHeader"
    let headerHeight = 25 + 16 * 2
    var menuHeader = ""
    
    func showMenu(header: String, menu: [MenuItem]){
        self.menuHeader = header
        self.menu = menu
        cvHeight = CGFloat(menu.count * rowHeight + headerHeight) + 40
        if let window = UIApplication.shared.keyWindow {
            collectionView.reloadData()
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: cvHeight)
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                
                self.dimView.alpha = 1
                let y = window.frame.height - self.cvHeight
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
        }
    }
    
    @objc func handleDismiss(){
        if let window = UIApplication.shared.keyWindow {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self.dimView.alpha = 0
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
        }
    }
    
    func setUp() {
        if dimView.alpha == 0 { return }
        if let window = UIApplication.shared.keyWindow {
            dimView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            dimView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(dimView)
            window.addSubview(collectionView)
            
            dimView.frame = window.frame
            dimView.alpha = 0
            
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: "MenuHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
            collectionView.register(UINib(nibName: "MenuCell", bundle: nil), forCellWithReuseIdentifier: cellID)
        }
    }
    
    override init(){
        super.init()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MenuCell
        if menu[indexPath.row].ic_rounded {
            cell.icon.layer.cornerRadius = 20
        }
        cell.title.text = menu[indexPath.row].title
        cell.content.text = menu[indexPath.row].content
        cell.icon.image = UIImage(named: menu[indexPath.row].icon)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: CGFloat(self.rowHeight))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handleDismiss()
        self.menuProtocol.getMenuItem(id: menu[indexPath.item].id)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! MenuHeader
        header.menuHeader.text = menuHeader
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: CGFloat(headerHeight))
    }
}
