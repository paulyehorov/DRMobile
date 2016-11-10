//
//  DataViewController.swift
//  DRMobile2
//
//  Created by Paul Yehorov on 11/10/16.
//  Copyright © 2016 Paul Yehorov. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var dataLabel: UILabel!
    var dataObject: String = ""


    @IBOutlet weak var textUserEmail: UITextField!
    @IBOutlet weak var textUserPassword: UITextField!
    @IBOutlet weak var textUserToken: UILabel!
    @IBAction func generateUserToken(_ sender: Any) {
        // create the request
        let request = NSMutableURLRequest(url: NSURL(string: "https://app.datarobot.com/api/v2/api_token") as! URL, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 5)
        
        // create some JSON data and configure the request
        let json = ["username": textUserEmail.text!, "password": textUserPassword.text!]
        self.textUserToken.text = "\(json))"
        let jsonData = try! JSONSerialization.data(withJSONObject: json)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
            if error != nil{
                print("Error -> \(error)")
                return
            }
            
            do {
                let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                
                print("Result -> \(result)")
                self.textUserToken.text! = "\(result)"
                
            } catch {
                print("Error -> \(error)")
            }
        }
        
        task.resume()
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataLabel!.text = dataObject
    }


}

