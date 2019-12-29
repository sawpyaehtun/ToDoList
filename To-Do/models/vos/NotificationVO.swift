//
//  NotificationVO.swift
//  To-Do
//
//  Created by sawpyaehtun on 09/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation

struct NotificationVO {
    let id : String
    let startNotificationID : String?
    let endNotificationID : String?
    let taskID : String?
}

extension NotificationVO {
    init?(dictionary : [String : Any]) {
        guard let id = dictionary["id"] as? String,
            let startNotificationID = dictionary["startNotificationID"] as? String,
            let endNotificationID = dictionary["endNotificationID"] as? String,
            let taskID = dictionary["taskID"] as? String else {return nil}
        self.startNotificationID = startNotificationID
        self.endNotificationID = endNotificationID
        self.taskID = taskID
        self.id = id
    }
}

extension NotificationVO {
    func toDictionary() -> [String : Any]{
        return [
            "id" : self.id as Any,
            "startNotificationID" : self.startNotificationID as Any,
            "endNotificationID" : self.endNotificationID as Any,
            "taskID" : self.taskID as Any
        ]
    }
}
