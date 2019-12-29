//
//  TaskVO.swift
//  To-Do
//
//  Created by sawpyaehtun on 09/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation

enum TaskState : Int {
    case normal = 0
    case completed = 1
    case failed = 2
}

struct TaskVO {
    var id : String?
    let remindMe : Bool?
    let title : String?
    let startDate : Date?
    let endDate : Date?
    let taskState : Int?
    let categoryId : String?
}

extension TaskVO {
    init?(dictionary : [String : Any]) {
        guard let id =  dictionary["id"] as? String,
            let remindMe =  dictionary["remindMe"] as? Bool,
            let title = dictionary["title"] as? String,
            let startDateString = dictionary["startDate"] as? String,
            let endDateString = dictionary["endDate"] as? String,
            let taskState = dictionary["taskState"] as? Int,
            let categoryId = dictionary["categoryId"] as? String else {return nil}
        if !startDateString.isEmpty {
            self.startDate = XTDateFormatterStruct.xt_defaultDateTimeFormatter().date(from: startDateString)
        } else {
            self.startDate = nil
        }

        if !endDateString.isEmpty {
            self.endDate = XTDateFormatterStruct.xt_defaultDateTimeFormatter().date(from: endDateString)
        } else {
            self.endDate = nil
        }
        
        
        self.title = title
        self.taskState = taskState
        self.id = id
        self.categoryId = categoryId
        self.remindMe = remindMe
    }
}

extension TaskVO {
    func toDictionary() -> [String : Any]{
        
        let startDate = XTDateFormatterStruct.xt_defaultDateTimeFormatter().string(from: self.startDate!)
        let endDate = XTDateFormatterStruct.xt_defaultDateTimeFormatter().string(from: self.endDate!)
        
        return [
            "id" : self.id as Any,
            "remindMe" : self.remindMe as Any,
            "title" : self.title as Any,
            "startDate" : startDate as Any,
            "endDate" : endDate as Any,
            "taskState" : self.taskState as Any,
            "categoryId" : self.categoryId as Any
        ]
    }
}
