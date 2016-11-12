//
//  FeaturesViewController.swift
//  DRMobile2
//
//  Created by Paul Yehorov on 11/11/16.
//  Copyright © 2016 Paul Yehorov. All rights reserved.
//

import UIKit

class FeaturesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var drService = DataRobotService.sharedInstance
    var projectId:String!
    
    @IBOutlet weak var featureTableView: UITableView!
    typealias FeatureInfo = (featureType: String, uniqueCount: Int, naCount: Int)
    var features:[String:FeatureInfo] = [:]

    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.features.count;
    }
    
    func tableView(_ tableViewt: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "DRFeaturesCell")
        let key = Array(self.features.keys)[indexPath.row]
        let info = self.features[key]!
        cell.backgroundColor = UIColor.init(white: 1, alpha: 0.25)
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white
        cell.textLabel?.text = key
        cell.detailTextLabel?.text = "\(info.featureType), uniques: \(info.uniqueCount), N/A: \(info.naCount)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "AdditionalImages/background.jpg")!)

        self.featureTableView.delegate = self
        self.featureTableView.dataSource = self
        
        featureTableView.backgroundColor = UIColor.init(white: 1, alpha: 0)
        featureTableView.tableFooterView = UIView(frame: .zero)
        
        refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refresh() {
        try! drService.getFeatures(projectId: projectId!) { result in
            var newFeatures:[String:FeatureInfo] = [:]
            for feature in result {
                let featureName = feature["name"] as! String
                let featureType = feature["featureType"] as! String
                let uniqueCount = feature["uniqueCount"] as! Int
                let naCount = feature["naCount"] as! Int
                
                newFeatures[featureName] = (featureType, uniqueCount, naCount)
            }
            self.features = newFeatures
            DispatchQueue.main.async(execute: {
                self.featureTableView.reloadData()
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
