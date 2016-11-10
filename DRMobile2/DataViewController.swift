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

    let drService = DataRobotService()

    @IBOutlet weak var textUserEmail: UITextField!
    @IBOutlet weak var textUserPassword: UITextField!
    @IBOutlet weak var textUserToken: UILabel!
    @IBAction func generateUserToken(_ sender: Any) {
        // create the request
        drService.login(username: String!(textUserEmail.text!), password: String!(textUserPassword.text!))
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

