//
//  DataRobotService.swift
//  DRMobile2
//
//  Created by Iaroslav Zeigerman on 11/10/16.
//  Copyright © 2016 Paul Yehorov. All rights reserved.
//

import Foundation

enum DataRobotServiceError: Error {
    case missingToken
}

class DataRobotService {
    
    private let baseUrl = "https://app.datarobot.com/api/v2/"
    private var apiToken = ""
    private var apiTokenTask: URLSessionDataTask? = nil
    
    private func sendRequest(requestJson: Any?, headers: [String:String], route: String, method: String, callback: @escaping (Any) -> Swift.Void) -> URLSessionDataTask {
        let url = "\(self.baseUrl)\(route)/"
        let request = NSMutableURLRequest(url: NSURL(string: url) as! URL, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 5)
        
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        for (key, val) in headers {
            request.setValue(val, forHTTPHeaderField: key)
        }
        if (method == "POST") {
            let jsonData = try! JSONSerialization.data(withJSONObject: requestJson, options: .prettyPrinted)
            request.httpBody = jsonData
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
            if error != nil {
                print("Error -> \(error)")
                return
            }
            
            do {
                let result = try JSONSerialization.jsonObject(with: data!, options: [])
                callback(result)
            } catch {
                print("Error -> \(error)")
                return
            }
        }
        task.resume()
        return task
    }
    
    private func checkToken() throws {
        if (self.apiTokenTask?.state != URLSessionTask.State.completed) {
            throw DataRobotServiceError.missingToken
        }
    }
    
    private func sendRequestWithToken(requestJson: Any?, route: String, method: String, callback: @escaping (Any) -> Swift.Void) throws -> URLSessionDataTask {
        try checkToken()
        let headers = [
            "Authorization": "Token \(self.apiToken)"
        ]
        return sendRequest(requestJson: requestJson, headers: headers, route: route, method: method, callback: callback)
    }
    
    private func getObjects(route: String, callback: @escaping ([[String:Any]]) -> Swift.Void) throws {
        try self.sendRequestWithToken(requestJson: nil, route: route, method: "GET") { result in
            let objects = result as! [[String:Any]]
            callback(objects)
        }
    }
    
    private func getObject(route: String, callback: @escaping ([String:Any]) -> Swift.Void) throws {
        try self.sendRequestWithToken(requestJson: nil, route: route, method: "GET") { result in
            let object = result as! [String:Any]
            callback(object)
        }
    }
    
    func waitForToken(timeout: UInt32, retries: Int) {
        for _ in 1...retries {
            do {
                try checkToken()
                return
            } catch {
                sleep(timeout)
            }
        }
    }
    
    func login(username: String, password: String, callback: @escaping (Bool) -> Swift.Void) {
        let request = ["username": username, "password": password]
        self.apiTokenTask = self.sendRequest(requestJson: request, headers: [:], route: "api_token", method: "POST") { result in
            let dict = result as! [String:Any]
            if dict["apiToken"] != nil {
                self.apiToken = dict["apiToken"] as! String
                callback(true)
            } else {
                callback(false)
            }
        }
    }
    
    func getProjects(callback: @escaping ([[String:Any]]) -> Swift.Void) throws {
        try getObjects(route: "projects", callback: callback)
    }
    
    func getProject(projectId: String, callback: @escaping ([String:Any]) -> Swift.Void) throws {
        try getObject(route: "projects/\(projectId)", callback: callback)
    }
    
    func getFeatures(projectId: String, callback: @escaping ([[String:Any]]) -> Swift.Void) throws {
        try getObjects(route: "projects/\(projectId)/features", callback: callback)
    }
    
    func getFeature(projectId: String, featureName: String, callback: @escaping ([String:Any]) -> Swift.Void) throws {
        try getObject(route: "projects/\(projectId)/features/\(featureName)", callback: callback)
    }
    
    func getFeatureLists(projectId: String, callback: @escaping ([[String:Any]]) -> Swift.Void) throws {
        try getObjects(route: "projects/\(projectId)/featurelists", callback: callback)
    }
    
    func getFeatureList(projectId: String, featureListId: String, callback: @escaping ([String:Any]) -> Swift.Void) throws {
        try getObject(route: "projects/\(projectId)/featurelists/\(featureListId)", callback: callback)
    }
    
    func getModels(projectId: String, callback: @escaping ([[String:Any]]) -> Swift.Void) throws {
        try getObjects(route: "projects/\(projectId)/models", callback: callback)
    }
    
    func getModel(projectId: String, modelId: String, callback: @escaping ([String:Any]) -> Swift.Void) throws {
        try getObject(route: "projects/\(projectId)/models/\(modelId)", callback: callback)
    }
}
