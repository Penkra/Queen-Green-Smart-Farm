//
//  Actions.swift
//  Queen Green Smart Farm
//
//  Created by Emmanuel Gyekye Atta-Penkra on 4/10/20.
//  Copyright © 2020 Special  Topics. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class Actions {
    static func getInfo(key: String) -> Any? {
        if USER_INFO[key] != nil {
            return USER_INFO[key]
        }else {
            let value = UserDefaults.standard.object(forKey: key)
            USER_INFO[key] = value
            return value
        }
    }
    
    static func saveInfo(key: String, value: Any){
        USER_INFO[key] = value
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func removeInfo(key: String){
        USER_INFO[key] = nil
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    static func removeAll(){
        USER_INFO = [:]
        UserDefaults.standard
            .removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }
    
    static func storeImage(urlString: String, image: UIImage){
        let path = NSTemporaryDirectory().appending(UUID().uuidString)
        let url = URL(fileURLWithPath: path)
        
        let data = image.jpegData(compressionQuality: 0.5)
        ((try? data?.write(to: url)) as ()??)
        
        var dict = UserDefaults.standard.object(forKey: "imageCache") as? [String: String]
        if dict == nil {
            dict = [String: String]()
        }
        
        dict![urlString] = path
        UserDefaults.standard.set(dict, forKey: "imageCache")
    }
    
    static func showImage(urlString: String, imageView: UIImageView){
        if let imageUrl = NSURL(string: urlString) {
            if let dict = UserDefaults.standard.object(forKey: "imageCache") as? [String: String]{
                if let path = dict[urlString] {
                    if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                        imageView.image = UIImage(data: data)
                        return
                    }
                }
            }
            
            URLSession.shared.dataTask(with: URLRequest(url: imageUrl as URL)) {(data, response, error) in
                if error != nil {
                    print(error ?? "Erorr occured with request")
                    return
                }
                DispatchQueue.main.async {
                    let imageData = UIImage(data: data!)
                    if imageData != nil {
                        imageView.image = imageData
                    }
                    self.storeImage(urlString: urlString, image: imageData!)
                }
            }.resume()
        }
    }
    
    static func isValidEmail(_ emailStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    static func showAlert(_ view: UIViewController, style: UIAlertController.Style, title: String, message: String, actions: [UIAlertAction]){
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alert.addAction(action)
        }
        view.present(alert, animated: true, completion: nil)
    }
    
    static func cancelAlertBtn() -> UIAlertAction {
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        return cancelAction
    }
    
    static func deepLink(_ view: UIViewController, urlString: String, failedStr: String, name: String, again: Bool){
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else if again {
            deepLink(view, urlString: failedStr, failedStr: "", name: name, again: false)
        }else {
            Actions.showAlert(view, style: .alert, title: "Cannot open \(name). Please make sure it is installed", message: "", actions: [UIAlertAction(title: "Okay", style: .default, handler: nil)])
        }
    }
    
    static func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "+X (XXX) XXX-XXXX"

        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        if result.count == 0 {
            result = "+1 "
        }
        return result
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func openURL(_ url: String){
        guard let url = URL(string: url) else {
            print("URL is not valid")
            return
        }
        self.present(SFSafariViewController(url: url), animated: true)
    }
    
    func showContactOptions(){
        Actions.showAlert(self, style: .actionSheet, title: "", message: "Contact Us", actions: [
            UIAlertAction(title: "Call Us 24/7", style: .default, handler: { _ in
                Actions.deepLink(self, urlString: "tel://2023681936", failedStr: "", name: "Call App", again: false)
            }),
            UIAlertAction(title: "Let's Text", style: .default, handler: { _ in
                Actions.deepLink(self, urlString: "sms:+2023681936&body=Hello from the Queen Green Smart Farm App:\n\n ", failedStr: "", name: "Messages", again: false)
            }),
            UIAlertAction(title: "Shoot An Email", style: .default, handler: { _ in
                Actions.showAlert(self, style: .actionSheet, title: "Send mail to:", message: "bewell@thehouseofj.net", actions: [
                    UIAlertAction(title: "iOS Mail", style: .default, handler: { _ in
                        Actions.deepLink(self, urlString: "message://%bewell@thehouseofj.net", failedStr: "https://apps.apple.com/us/app/mail/id1108187098", name: "Mail App", again: true)
                    }),
                    UIAlertAction(title: "Gmail", style: .default, handler: { _ in
                        Actions.deepLink(self, urlString: "googlegmail:co?to=bewell@thehouseofj.net&subject=Hello from the Queen Green Smart Farm App:&body=", failedStr: "https://apps.apple.com/us/app/gmail-email-by-google/id422689480", name: "Gmail", again: true)
                    }),
                    UIAlertAction(title: "Outlook", style: .default, handler: { _ in
                        Actions.deepLink(self, urlString: "ms-outlook:compose?to=bewell@thehouseofj.net&subject=Hello from the Queen Green Smart Farm App:&body=", failedStr: "https://apps.apple.com/us/app/microsoft-outlook/id951937596", name: "Outlook", again: false)
                    }),
                    Actions.cancelAlertBtn()
                ])
            }),
//            UIAlertAction(title: "Whatsapp", style: .default, handler: { _ in
//                Actions.deepLink(self, urlString: "whatsapp:send?phone=+18038781772&text=", failedStr: "https://apps.apple.com/us/app/whatsapp-messenger/id310633997", name: "Whatsapp", again: false)
//            }),
            Actions.cancelAlertBtn()
        ])
    }
}

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    func dayOfWeek() -> Character {
        switch (dayNumberOfWeek()){
        case 1: return "Y"
        case 2: return "M"
        case 3: return "T"
        case 4: return "W"
        case 5: return "R"
        case 6: return "F"
        case 7: return "S"
        default: return "0"
        }
    }
}

extension UITextField {
    func setLeftnRightPadding(_ amount: CGFloat){
        setLeftPaddingPoints(amount)
        setRightPaddingPoints(amount)
    }
    
    func setLeftPaddingPoints(_ amount: CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width - 80, height: self.bounds.size.height))
        messageLabel.text = message
        if #available(iOS 13.0, *) {
            messageLabel.textColor = .label
        } else {
            messageLabel.textColor = .black
        }
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "System-Regular", size: 17)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
