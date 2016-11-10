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

    @IBOutlet weak var tableProjectsList: UITableView!
    @IBOutlet weak var textDebugLabel: UILabel!
    
    var projectsList: [String:String] = [:]
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableProjectsList.delegate = self
        self.tableProjectsList.dataSource = self
        // Do any additional setup after loading the view.
        
        try! drService.getProjects { result in
            for project in result {
                let projectName = project["projectName"] as! String
                let projectId = project["id"] as! String
                self.projectsList[projectId] = projectName
            }
            print(self.projectsList)
            
            DispatchQueue.main.async(execute: {
                self.tableProjectsList.reloadData()
            })
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
