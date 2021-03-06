//
//  ProjectsViewController.swift
//  DRMobile2
//
//  Created by Paul Yehorov on 11/10/16.
//  Copyright © 2016 Paul Yehorov. All rights reserved.
//

import UIKit

class ProjectsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let drService = DataRobotService.sharedInstance
    
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var tableProjectsList: UITableView!
    
    var projectsList: [String:String] = [:]
    var projectIdToPass: String = ""
    
    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.projectsList.count;
    }
    
    func tableView(_ tableViewt: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "DRCell")
        let key = Array(self.projectsList.keys)[indexPath.row]
        cell.backgroundColor = UIColor.init(white: 1, alpha: 0.25)
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white
        cell.textLabel?.text = self.projectsList[key]
        cell.detailTextLabel?.text = key
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow;
        
        projectIdToPass = Array(self.projectsList.keys)[indexPath!.row]
        performSegue(withIdentifier: "moveToModelsList", sender: self)
        tableView.deselectRow(at: indexPath!, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "moveToModelsList") {
            let tabController = segue.destination as! UITabBarController
            let modeListController = tabController.viewControllers![0] as! ModelsListViewController
            modeListController.projectId = projectIdToPass
            
            let featuresController = tabController.viewControllers![1] as! FeaturesViewController
            featuresController.projectId = projectIdToPass
            
            let featureListController = tabController.viewControllers![2] as! FeaturesListViewController
            featureListController.projectId = projectIdToPass
            
            let modelingController = tabController.viewControllers![3] as! ModelingViewController
            modelingController.projectId = projectIdToPass
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "AdditionalImages/background.jpg")!)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(ProjectsViewController.refresh), for: UIControlEvents.valueChanged)
        
        self.tableProjectsList.delegate = self
        self.tableProjectsList.dataSource = self
        self.tableProjectsList.addSubview(self.refreshControl)
        
        tableProjectsList.backgroundColor = UIColor.init(white: 1, alpha: 0)
        tableProjectsList.tableFooterView = UIView(frame: .zero)
        
        refresh()
    }
    
    func refresh() {
        try! drService.getProjects { result in
            var newProjectsList: [String:String] = [:]
            for project in result {
                let projectName = project["projectName"] as! String
                let projectId = project["id"] as! String
                newProjectsList[projectId] = projectName
            }
            self.projectsList = newProjectsList
            DispatchQueue.main.async(execute: {
                self.tableProjectsList.reloadData()
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
