//
//  CreateFeatureListViewController.swift
//  DRMobile2
//
//  Created by Iaroslav Zeigerman on 11/11/16.
//  Copyright © 2016 Paul Yehorov. All rights reserved.
//

import UIKit

class CreateFeatureListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var featureTableView: UITableView!
    
    var drService = DataRobotService.sharedInstance
    var projectId: String!
    
    typealias FeatureInfo = (featureType: String, uniqueCount: Int, naCount: Int)
    var features:[String:FeatureInfo] = [:]
    var checkedFeatures = Set<String>()
    
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
        
        cell.accessoryType = UITableViewCellAccessoryType.checkmark
        checkedFeatures.insert(key)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let cell = self.featureTableView.cellForRow(at: indexPath!)!
        let name = cell.textLabel?.text
        if checkedFeatures.contains(name!) {
            cell.accessoryType = UITableViewCellAccessoryType.none
            checkedFeatures.remove(name!)
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            checkedFeatures.insert(name!)
        }
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
    
    @IBAction func saveFeatureList(_ sender: Any) {
        let date = Int(NSDate.timeIntervalSinceReferenceDate)
        let listName = "Feature List \(date)"
        try! drService.createFeatureList(projectId: projectId, name: listName, features: Array(checkedFeatures)) {
        }
        self.performSegue(withIdentifier: "backToFeatureList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "backToFeatureList") {
            let tabController = segue.destination as! UITabBarController
            let modeListController = tabController.viewControllers![0] as! ModelsListViewController
            modeListController.projectId = projectId
            
            let featuresController = tabController.viewControllers![1] as! FeaturesViewController
            featuresController.projectId = projectId
            
            let featureListController = tabController.viewControllers![2] as! FeaturesListViewController
            featureListController.projectId = projectId
            
            let modelingController = tabController.viewControllers![3] as! ModelingViewController
            modelingController.projectId = projectId
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
