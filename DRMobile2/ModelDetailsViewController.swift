//
//  ModelDetailsViewController.swift
//  DRMobile2
//
//  Created by Iaroslav Zeigerman on 11/11/16.
//  Copyright © 2016 Paul Yehorov. All rights reserved.
//

import UIKit

class ModelDetailsViewController: UIViewController {

    var modelId: String!
    var projectId: String!
    var drService = DataRobotService.sharedInstance
    
    var modelName: String = ""
    var featurelistName: String = ""
    var modelCategory: String = ""
    var samplePct: Int = 0
    var metrics: [String:MetricInfo] = [:]
    
    typealias MetricInfo = (holdout: Double?, validation: Double?, crossValidation: Double?)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func refresh() {
        try! drService.getModel(projectId: projectId, modelId: modelId) { model in
            self.modelName = model["modelType"] as! String
            self.featurelistName = model["featurelistName"] as! String
            self.modelCategory = model["modelCategory"] as! String
            self.samplePct = model["samplePct"] as! Int
            
            let rawMetrics = model["metrics"] as! [String:Any]
            
            self.metrics = [:]
            for (name, data) in rawMetrics {
                let rawInfo = data as! [String:Any]
                let holdout = rawInfo["holdout"] as? Double
                let validation = rawInfo["validation"] as? Double
                let crossValidation = rawInfo["crossValidation"] as? Double
                
                self.metrics[name] = (holdout, validation, crossValidation)
            }
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
