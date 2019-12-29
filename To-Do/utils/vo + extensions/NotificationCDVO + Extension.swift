//
//  NotificationCDVO + Extension.swift
//  To-Do
//
//  Created by sawpyaehtun on 20/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation

extension NotificationCDVO {
    func toNotificationVO() -> NotificationVO {
        return NotificationVO(id: self.id ?? "", startNotificationID: self.startNotificationID, endNotificationID: self.endNotificationID, taskID: self.taskID)
    }
}
