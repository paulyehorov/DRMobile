//
//  ModelDetailsViewController.swift
//  DRMobile2
//
//  Created by Iaroslav Zeigerman on 11/11/16.
//  Copyright © 2016 Paul Yehorov. All rights reserved.
//

import UIKit

class ModelDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var modelId: String!
    var projectId: String!
    var drService = DataRobotService.sharedInstance
    
    var modelName: String = ""
    var featurelistName: String = ""
    var modelCategory: String = ""
    var samplePct: Int = 0
    var metrics: [String:MetricInfo] = [:]
    
    @IBOutlet weak var textModelName: UILabel!
    @IBOutlet weak var textFeatureListName: UILabel!
    @IBOutlet weak var textModelCategory: UILabel!
    @IBOutlet weak var textSampleSize: UILabel!
    @IBOutlet weak var metricsTable: UITableView!
    
    typealias MetricInfo = (holdout: Double?, validation: Double?, crossValidation: Double?)
    
    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.metrics.count;
    }
    
    func tableView(_ tableViewt: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "DRCell")
        let key = Array(self.metrics.keys)[indexPath.row]
        let info = self.metrics[key]
        cell.backgroundColor = UIColor.init(white: 1, alpha: 0.25)
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white
        cell.textLabel?.text = key
        
        let holdout: Any = info?.holdout ?? "N/A"
        let crossValidation: Any = info?.crossValidation ?? "N/A"
        let validation: Any = info?.validation ?? "N/A"
        //let crossValid
        cell.detailTextLabel?.text = "H: \(holdout), V: \(validation), CV: \(crossValidation)"
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "AdditionalImages/background.jpg")!)

        self.metricsTable.delegate = self
        self.metricsTable.dataSource = self
        self.metricsTable.backgroundColor = UIColor.init(white: 1, alpha: 0)
        self.metricsTable.tableFooterView = UIView(frame: .zero)
        
        UITabBar.appearance().tintColor = UIColor(red: 253/255.0, green: 103/255.0, blue: 33/255.0, alpha: 1.0)
        
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
            
            DispatchQueue.main.async(execute: {
                self.textModelName.text = "\(self.modelName)"
                self.textFeatureListName.text = "\(self.featurelistName)"
                self.textModelCategory.text = "\(self.modelCategory)"
                self.textSampleSize.text = "\(Int(self.samplePct)) %"
                self.metricsTable.reloadData()
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
