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

    let drService = DataRobotService.sharedInstance
    let drNotifier = DataRobotNotifier.sharedInstance

    @IBOutlet weak var textUserEmail: UITextField!
    @IBOutlet weak var textUserPassword: UITextField!
    @IBOutlet weak var textUserToken: UILabel!
    @IBOutlet weak var buttonLogIn: UIButton!
    @IBAction func generateUserToken(_ sender: Any) {
        // create the request
        drService.login(username: String!(textUserEmail.text!), password: String!(textUserPassword.text!)) { isSuccess in
            if (isSuccess) {
                print("LOGIN SUCCEED")
                self.drNotifier.start()
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "moveToProjectsList", sender: self)
                }
            } else {
                print("LOGIN FAILED")
                OperationQueue.main.addOperation {
                    let alert = UIAlertController(title: "Authentication failed", message: "Please try again", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "AdditionalImages/background.jpg")!)
        
        let btnImage = UIImage(named: "AdditionalImages/Rectangle.png")
        buttonLogIn.setBackgroundImage(btnImage, for: UIControlState.normal)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataLabel!.text = dataObject
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


}

