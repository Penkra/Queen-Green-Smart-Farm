//
//  Internet.swift
//  Queen Green Smart Farm
//
//  Created by Emmanuel Gyekye Atta-Penkra on 4/24/20.
//  Copyright © 2020 Special  Topics. All rights reserved.
//

import Foundation

protocol Response {
    func getResponse(data: Data, identifier: Int)
    func getError(err: String, msg: String, identifier: Int)
}

class Internet {
    
    var reqResponse: Response!
    
    func request(url: String, method: String, parameters: [String: Any], identifier: Int) {
        
        //ADD TO QUEUE
//        if REQUESTING { return }
//        REQUESTING = true
        
        guard let url = URL(string: url) else {
            self.reqResponse.getError(err: "Error occured at creating URL", msg: "", identifier: identifier)
            return
        }
        
        var request = URLRequest(url: url)
        var components = URLComponents()
        var queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name : key, value : String(describing: value)))
        }
        components.queryItems = queryItems
        
        request.httpBody = components.query?.data(using: .utf8)
        request.httpMethod = method
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request){(data, response, error) in
            DispatchQueue.main.async {
//                REQUESTING = false
                guard let _ = response as? HTTPURLResponse else {
                    self.reqResponse.getError(err: "Please connect to the internet", msg: "", identifier: identifier)
                    return
                }
                //                print(unwrappedResponse.statusCode)
                //                switch unwrappedResponse.statusCode {
                //                case 200 ..< 300:
                //                    print("Success")
                //                default:
                //                    print("Failure")
                //                }
                
                if let _ = error {
                    self.reqResponse.getError(err: "Error at receiving response", msg: "", identifier: identifier)
                    return
                }
                
                if let unwrappedData = data {
                    self.reqResponse.getResponse(data: unwrappedData, identifier: identifier)
                    return
                }
            }
        }.resume()
    }
}
