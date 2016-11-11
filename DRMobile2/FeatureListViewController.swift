//
//  FeaturesListViewController.swift
//  DRMobile2
//
//  Created by Paul Yehorov on 11/11/16.
//  Copyright © 2016 Paul Yehorov. All rights reserved.
//

import UIKit

class FeaturesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var featureListsTableView: UITableView!
    var projectId:String!
    
    var drService = DataRobotService.sharedInstance
    var featureLists: [String:String] = [:]
    
    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.featureLists.count;
    }
    
    func tableView(_ tableViewt: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "DRFeatureListsCell")
        let key = Array(self.featureLists.keys)[indexPath.row]
        let name = self.featureLists[key]!
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = key
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.featureListsTableView.delegate = self
        self.featureListsTableView.dataSource = self
        
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
            DispatchQueue.main.async(execute: {
                self.featureListsTableView.reloadData()
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
