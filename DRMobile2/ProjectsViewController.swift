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
        cell.textLabel?.text = self.projectsList[key]
        cell.detailTextLabel?.text = key
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: go to project details here (on cell tap handler)
        let indexPath = tableView.indexPathForSelectedRow;
        
        let projectIdToPass = Array(self.projectsList.keys)[indexPath!.row]
        performSegue(withIdentifier: "moveToModelsList", sender: self)
        print("\(projectIdToPass)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "moveToModelsList") {
            let viewController = segue.destination as! ModelsListViewController
            viewController.passedProjectId = projectIdToPass
            print(viewController.passedProjectId)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(ProjectsViewController.refresh), for: UIControlEvents.valueChanged)
        
        self.tableProjectsList.delegate = self
        self.tableProjectsList.dataSource = self
        self.tableProjectsList.addSubview(self.refreshControl)
        
        refresh()
    }
    
    func refresh() {
        try! drService.getProjects { result in
            for project in result {
                let projectName = project["projectName"] as! String
                let projectId = project["id"] as! String
                self.projectsList[projectId] = projectName
            }
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
