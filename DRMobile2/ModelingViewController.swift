//
//  ModelingViewController.swift
//  DRMobile2
//
//  Created by Paul Yehorov on 11/11/16.
//  Copyright © 2016 Paul Yehorov. All rights reserved.
//

import UIKit

class ModelingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var runModelButton: UIButton!
    @IBOutlet weak var targetTextField: UITextField!
    @IBOutlet weak var featureListPicker: UIPickerView!
    
    var drNotifier = DataRobotNotifier.sharedInstance
    var drService = DataRobotService.sharedInstance
    
    var featureLists: [String:String] = [:]
    var projectId:String!
    
    var selectedList: String = ""
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return featureLists.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let key = Array(self.featureLists.keys)[row]
        let name = self.featureLists[key]!
        return name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let key = Array(self.featureLists.keys)[row]
        selectedList = key
    }
    
    @IBAction func runModel(_ sender: Any) {
        let target = targetTextField.text!
        try! drService.setTarget(projectId: projectId, target: target) {
            try! self.drService.startAutopilot(projectId: self.projectId, featureListId: self.selectedList) {
                self.drNotifier.sendNotificationForProject(title: "The Autopilot has been started", body: "Check out your models soon", projectId: self.projectId!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.featureListPicker.delegate = self
        self.featureListPicker.dataSource = self
        
        refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh() {
        try! drService.getFeatureLists(projectId: projectId!) { result in
            var newFeatureLists:[String:String] = [:]
            for featureList in result {
                let name = featureList["name"] as! String
                let id = featureList["id"] as! String
                
                newFeatureLists[id] = name
            }
            self.featureLists = newFeatureLists
            self.selectedList = self.featureLists.keys.first!
            DispatchQueue.main.async(execute: {
                self.featureListPicker.reloadAllComponents()
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
