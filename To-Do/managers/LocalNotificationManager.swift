//
//  LocalNotificationManager.swift
//  LocalNotificationTestProject
//
//  Created by sawpyaehtun on 07/12/2019.
//  Copyright © 2019 sawpyaehtun. All rights reserved.
//

import UIKit
import UserNotifications

class LocalNotificationManager {
    let content = UNMutableNotificationContent()
    static let shared = LocalNotificationManager()
    var badgeNumber = 0
    static let notificationTitle = "To Do List"
    static let notificationSubTitleForStart = "Your task will start in next 15 minutes!"
    static let notificationSubTitleForEnd = "Your task is ended!"
}

extension LocalNotificationManager {
    func clearBadge() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        badgeNumber = 0
    }
    
    func addRequestNotificationForStartTask(title : String = LocalNotificationManager.notificationTitle, subTitle : String = LocalNotificationManager.notificationSubTitleForStart, body : String, date : Date,identifier : String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subTitle
        content.body = body
        badgeNumber = 1
        content.badge = badgeNumber as NSNumber
        
        print(identifier)
        
        var dateComponents = DateComponents()
        dateComponents.timeZone = .current
        dateComponents.year = date.getCurrentYear()
        dateComponents.month = date.getCurrentMonth()
        dateComponents.day = date.getCurrentDay()
        dateComponents.hour = date.getCurrentHour()
        dateComponents.minute = date.getCurrentMinute() - 15
        
//        print(dateComponents.year)
//        print(dateComponents.month)
//        print(dateComponents.day)
//        print(dateComponents.hour)
//        print(dateComponents.minute)
//        print(dateComponents.second)
        
        //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(tfTime.text ?? "0")!, repeats: false)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    
    func addRequestNotificationForEndTask(title : String = LocalNotificationManager.notificationTitle, subTitle : String = LocalNotificationManager.notificationSubTitleForEnd, body : String, date : Date,identifier : String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subTitle
        content.body = body
        badgeNumber = 1
        content.badge = badgeNumber as NSNumber
    
        print(identifier)
        var dateComponents = DateComponents()
        dateComponents.timeZone = .current
        dateComponents.year = date.getCurrentYear()
        dateComponents.month = date.getCurrentMonth()
        dateComponents.day = date.getCurrentDay()
        dateComponents.hour = date.getCurrentHour()
        dateComponents.minute = date.getCurrentMinute()
       
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
