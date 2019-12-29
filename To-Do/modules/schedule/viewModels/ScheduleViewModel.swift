//
//  SchduleViewModel.swift
//  To-Do
//
//  Created by sawpyaehtun on 17/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ScheduleViewModel: BaseViewModel {
    let allTaskBehaviorRelay = BehaviorRelay<[TaskVO]>(value: [])
}

extension ScheduleViewModel {
    
    func getAllTask() {
        loadingObservable.accept(true)
        TaskProvider.shared.getAllTaskFromFireStore().subscribe(onNext: { (taskList) in
            self.loadingObservable.accept(false)
            self.allTaskBehaviorRelay.accept(taskList)
        }, onError: { (error) in
            self.errorObservable.accept(error.localizedDescription)
        }).disposed(by: disposableBag)
    }
    
    func updateTask(taskToUpdate : TaskVO) {
        loadingObservable.accept(true)
        NotificationProvider.shared.getAllNotiFromFireStore().subscribe(onNext: { (notificationList) in
            let notiList = notificationList.filter { (notification) -> Bool in
                notification.taskID == taskToUpdate.id!
            }
            if !notiList.isEmpty {
                if let noti = notiList.first {
                    NotificationProvider.shared.addNotificationRequestToDevice(task: taskToUpdate, noti: noti)
                }
                
                TaskProvider.shared.updateTaskInFireStore(task: taskToUpdate){
                    self.getAllTask()
                    
                }
            }
        }).disposed(by: disposableBag)
    }
}
