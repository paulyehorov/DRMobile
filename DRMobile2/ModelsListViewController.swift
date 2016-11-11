//
//  ModelsListViewController.swift
//  DRMobile2
//
//  Created by Paul Yehorov on 11/11/16.
//  Copyright © 2016 Paul Yehorov. All rights reserved.
//

import UIKit

class ModelsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    let drService = DataRobotService.sharedInstance
    
    var projectId:String!
    var refreshControl: UIRefreshControl!
    var modelsList: [String:String] = [:]
    var modelIdToPass: String = ""
    
    @IBOutlet weak var tableModelsList: UITableView!
    
    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.modelsList.count;
    }
    
    func tableView(_ tableViewt: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "DRCell")
        let key = Array(self.modelsList.keys)[indexPath.row]
        let name = self.modelsList[key]
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = key
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(ProjectsViewController.refresh), for: UIControlEvents.valueChanged)
        
        self.tableModelsList.delegate = self
        self.tableModelsList.dataSource = self
        self.tableModelsList.addSubview(self.refreshControl)
        
        refresh()
    }

    func refresh() {
        try! drService.getModels(projectId: projectId) { result in
            for model in result {
                let modelName = model["modelType"] as! String
                let modelId = model["id"] as! String
                
                self.modelsList[modelId] = modelName
            }
            DispatchQueue.main.async(execute: {
                self.tableModelsList.reloadData()
            })
            self.refreshControl?.endRefreshing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
