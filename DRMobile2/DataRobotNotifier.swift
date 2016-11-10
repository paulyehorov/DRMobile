//
//  DataRobotNotifier.swift
//  DRMobile2
//
//  Created by Iaroslav Zeigerman on 11/10/16.
//  Copyright © 2016 Paul Yehorov. All rights reserved.
//

import Foundation

import  UserNotifications

class DataRobotNotifier: NSObject, UNUserNotificationCenterDelegate {
    
    private let pollInterval: UInt32 = 1
    private let drService = DataRobotService.sharedInstance
    private let requestIdentifier = "DataRobotRequest"
    private var isFirstRun: Bool = true
    private var isRunning: Bool = false
    
    private var projects: [String:String] = [:]
    private var projectToJobs: [String:[String:String]] = [:]
    
    private func sendNotification(title: String, subtitle: String, body: String) {
        print("Notification will be triggered in five seconds.")
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = UNNotificationSound.default()
        
        // Deliver the notification in five seconds.
        //let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5.0, repeats: false)
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: nil)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request){ error in
            if (error != nil) {
                print(error!.localizedDescription)
            }
        }
    }
    
    private func updateProjects() throws {
        try! drService.getProjects { result in
            var newProjects: [String: String] = [:]
            for project in result {
                let projectId = project["id"] as! String
                newProjects[projectId] = project["projectName"] as! String
            }
            if (!self.isFirstRun) {
                let diff = Set(newProjects.keys).subtracting(Set(self.projects.keys))
                for id in diff {
                    self.sendNotification(title: "Project has been created", subtitle: "\(newProjects[id]!)", body: "New project ID: \(id)")
                }
            }
            self.projects = newProjects
            self.isFirstRun = false
        }
    }
    
    private func run() throws {
        while (isRunning) {
            try! updateProjects()

            sleep(pollInterval)
        }
    }
    
    func start() {
        isRunning = true
        DispatchQueue.global(qos: .background).async {
            try! self.run()
        }
    }
    
    func stop() {
        isRunning = false
        isFirstRun = true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == requestIdentifier {
            completionHandler( [.alert,.sound,.badge])
        }
    }
}
