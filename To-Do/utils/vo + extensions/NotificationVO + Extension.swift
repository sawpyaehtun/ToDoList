//
//  NotificationVO + Extension.swift
//  To-Do
//
//  Created by sawpyaehtun on 20/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation

extension NotificationVO {
    func  toNotificationCDVO() -> NotificationCDVO {
        let notificationCDVO = NotificationCDVO(context: PersistenceManager.shared.persistanceContainer.viewContext)
        notificationCDVO.id = self.id
        notificationCDVO.startNotificationID = self.startNotificationID
        notificationCDVO.endNotificationID = self.endNotificationID
        notificationCDVO.taskID = self.taskID
        
        return notificationCDVO
    }
}
