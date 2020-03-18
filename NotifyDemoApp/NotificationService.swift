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
    
    func scheduleNotification(notificationType: String) {
        
        let firstNotification = "First Notification"
        let remindShortAction = UNNotificationAction(identifier: "Remind5", title: "Напомни мне через 5 мин", options: [])
        let remindLongAction = UNNotificationAction(identifier: "Remind15", title: "Напомни мне через 15 мин", options: [])
        let readyAction = UNNotificationAction(identifier: "Ready", title: "Вперед!", options: [])
        let firstNotificationCategory = UNNotificationCategory(identifier: firstNotification,
                                              actions: [readyAction, remindShortAction, remindLongAction],
                                              intentIdentifiers: [],
                                              options: [])
        notificationCenter.setNotificationCategories([firstNotificationCategory])
        
        let content = UNMutableNotificationContent()
        content.title = notificationType
        content.body = "This is example how to create " + notificationType
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = firstNotification
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let identifier = notificationType
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
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
        case "Ready":
            print("Ready Action")
        case "Remind5":
            print("Remind5 Action")
            scheduleNotification(notificationType: "Second Notification")
        case "Remind15":
            print("Remind15 Action")
        default:
            print("Unknown Action")
        }
        
        completionHandler()
    }
}
