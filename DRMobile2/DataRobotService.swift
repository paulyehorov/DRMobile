//
//  DataRobotService.swift
//  DRMobile2
//
//  Created by Iaroslav Zeigerman on 11/10/16.
//  Copyright © 2016 Paul Yehorov. All rights reserved.
//

import Foundation

class DataRobotService {
    
    private let baseUrl = "https://app.datarobot.com/api/v2/"
    private var apiToken = ""
    
    private func sendRequest(requestJson: Any, route: String, method: String, callback: @escaping ([String:Any]) -> Swift.Void) {
        let url = "\(self.baseUrl)\(route)/"
        let request = NSMutableURLRequest(url: NSURL(string: url) as! URL, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 5)
        
        let jsonData = try! JSONSerialization.data(withJSONObject: requestJson, options: .prettyPrinted)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if (method == "POST") {
            request.httpBody = jsonData
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
            if error != nil {
                print("Error -> \(error)")
                return
            }
            
            do {
                let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                callback(result)
            } catch {
                print("Error -> \(error)")
                return
            }
        }
        task.resume()
    }
    
    func login(username: String, password: String) {
        let request = ["username": username, "password": password]
        self.sendRequest(requestJson: request, route: "api_token", method: "POST") { result in
            self.apiToken = result["apiToken"] as! String
        }
    }
    
    func getProjects(callback: @escaping ([String:Any]) -> Swift.Void) {
        
    }
}
