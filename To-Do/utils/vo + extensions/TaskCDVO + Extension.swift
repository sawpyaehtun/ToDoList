//
//  TaskCDVO + Extension.swift
//  To-Do
//
//  Created by sawpyaehtun on 20/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation

extension TaskCDVO {
    func toTaskVO() -> TaskVO {
        var startDate = Date()
        var endDate = Date()
        
        if let startDateString = self.startDate, !startDateString.isEmpty {
            startDate =  XTDateFormatterStruct.xt_defaultDateTimeFormatter().date(from: startDateString) ?? Date()
        }
        
        if let endDateString = self.endDate, !endDateString.isEmpty {
            endDate =  XTDateFormatterStruct.xt_defaultDateTimeFormatter().date(from: endDateString) ?? Date()
        }
        
        
        return TaskVO(id: self.id, remindMe: self.remindMe, title: self.title, startDate: startDate, endDate: endDate, taskState: Int(self.taskState), categoryId: self.categoryId)
        
    }
}
