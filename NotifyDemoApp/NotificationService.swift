//
//  NotificationService.swift
//  Notifications
//
//  Created by Алексей Пархоменко on 17.03.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationService: NSObject {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAutorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            print("Permittion granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
        }
    }
    
    func configureNotification() {
        
    }
    
    func scheduleNotification(notifaicationType: String) {
        
        let content = UNMutableNotificationContent()
        let userAction = "User Action"
        
        content.title = notifaicationType
        content.body = "This is example how to create " + notifaicationType
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = userAction
        
//        guard let path = Bundle.main.path(forResource: "banking", ofType: "png") else { return }
//        let url = URL(fileURLWithPath: path)
//
//        do {
//            let attachment = try UNNotificationAttachment(identifier: "banking", url: url, options: nil)
//            content.attachments = [attachment]
//        } catch {
//            print("The attachment could not be loaded")
//        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let identifire = notifaicationType
        let request = UNNotificationRequest(identifier: identifire,
                                            content: content,
                                            trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            print("kek")
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(identifier: userAction,
                                              actions: [snoozeAction, deleteAction],
                                              intentIdentifiers: [],
                                              options: [])
        notificationCenter.setNotificationCategories([category])
        
    }
    
}

// MARK: - UNUserNotificationCenterDelegate
extension NotificationService: UNUserNotificationCenterDelegate {
    // вызывается когда получаем уведомление при открытом приложении
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        if response.notification.request.identifier == "Local Notification" {
            print("Handling notification with the Local Notification Identifire")
        }
        
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default Action")
        case "Snooze":
            print("Snooze Action")
            scheduleNotification(notifaicationType: "Second Notification")
        case "Delete":
            print("Delete Action")
        default:
            print("Unknown Action")
        }
        
        completionHandler()
    }
}
