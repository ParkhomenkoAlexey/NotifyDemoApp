//
//  ViewController.swift
//  NotifyDemoApp
//
//  Created by Алексей Пархоменко on 17.03.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    let notificationService = NotificationService()
    
    let notificationsType = ["Local Notification",
                         "Second Notification",
                         "Laudatory Notification",
                         "Three Refuse Notification",
                         "Six Refuse Notification"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsType.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = notificationsType[indexPath.row]
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = .red
        
        let notificationType = notificationsType[indexPath.row]
        
        let alert = UIAlertController(title: notificationType,
                                      message: "After 5 seconds " + notificationType + " will appear",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.notificationService.scheduleNotification(notifaicationType: notificationType)
        }
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = .white
    }
}

