//
//  Array + Extension.swift
//  To-Do
//
//  Created by sawpyaehtun on 20/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation

extension Array {
    func toCategoryVOs() -> [CategoryVO] {
        guard let categoryCDVOs = self as? [CategoryCDVO] else { return []}
        let categoryVOs = categoryCDVOs.map { (categoryCDVO) -> CategoryVO in
            return categoryCDVO.toCategoryVO()
        }
        return categoryVOs
    }
    
    func toNotificationVOs() -> [NotificationVO] {
        guard let notificationCDVOs = self as? [NotificationCDVO] else { return []}
        let notificationVOs = notificationCDVOs.map { (notificationCDVO) -> NotificationVO in
            return notificationCDVO.toNotificationVO()
        }
        return notificationVOs
    }
    
    func toTaskVOs() -> [TaskVO] {
        guard let taskCDVOs = self as? [TaskCDVO] else { return []}
        let taskVOs = taskCDVOs.map { (taskCDVO) -> TaskVO in
            return taskCDVO.toTaskVO()
        }
        return taskVOs
    }
}
