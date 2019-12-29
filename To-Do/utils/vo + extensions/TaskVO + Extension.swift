//
//  TaskVO + Extension.swift
//  To-Do
//
//  Created by sawpyaehtun on 20/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation

extension TaskVO {
    func toTaskCDVO() -> TaskCDVO {
        let taskCDVO = TaskCDVO(context: PersistenceManager.shared.persistanceContainer.viewContext)
        taskCDVO.id = self.id
        taskCDVO.remindMe = self.remindMe ?? false
        taskCDVO.title = self.title
        taskCDVO.startDate = XTDateFormatterStruct.xt_defaultDateTimeFormatter().string(from: self.startDate!)
        taskCDVO.endDate = XTDateFormatterStruct.xt_defaultDateTimeFormatter().string(from: self.endDate!)
        taskCDVO.taskState = Int32(self.taskState ?? 0)
        taskCDVO.categoryId = self.categoryId
          
        return taskCDVO
    }
}
