//
//  CreateNewTaskViewModel.swift
//  To-Do
//
//  Created by sawpyaehtun on 12/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class CreateNewTaskViewModel: BaseViewModel {
    var categoryListBehaviorRelay = BehaviorRelay<[CategoryVO]>(value: [])
    var startDateBehaviorRelay = BehaviorRelay<Date>(value: Date())
    var titleSelectedCategory = BehaviorRelay<String>(value: "")
    var endDateBehaviorRelay = BehaviorRelay<Date>(value: Date())
    var taskTitleBehaviorRelay = BehaviorRelay<String>(value: "")
    var isRemaindMeBehaviorRelay = BehaviorRelay<Bool>(value: true)
    var categoryTitleBehaviorRelay = BehaviorRelay<String>(value: "")
    var selectedCategoryIndex = BehaviorRelay<Int>(value: 0)
    var selectedDayObserable : Observable<String> {
        return startDateBehaviorRelay.map { (date) -> String in
            XTDateFormatterStruct.xt_appDateFormatter().string(from: date)
        }
    }
    
    var isCreateNewTaskBtnEnable : Observable<Bool> {
        return taskTitleBehaviorRelay.map { (txt) -> Bool in
            return !txt.isEmpty
        }
    }
    
    var startTimeEndTimeObserable : Observable<String>{
        return Observable.combineLatest(startDateBehaviorRelay.asObservable(),endDateBehaviorRelay.asObservable()){ startDate, endDate in
            "\(XTDateFormatterStruct.xt_12HourFormatTimeFormatter().string(from: startDate)) - \(XTDateFormatterStruct.xt_12HourFormatTimeFormatter().string(from: endDate))"
        }
    }
    
    override init() {
        super.init()
        selectedCategoryIndex.subscribe(onNext: { (index) in
            if !self.categoryListBehaviorRelay.value.isEmpty {
                self.categoryTitleBehaviorRelay.accept(self.categoryListBehaviorRelay.value[index].name!)
            }
        }).disposed(by: disposableBag)
    }
    
    func createNewTask() {
        loadingObservable.accept(true)
        let task = TaskVO(id: Date().getCurrentMilliSec(), remindMe: isRemaindMeBehaviorRelay.value, title: taskTitleBehaviorRelay.value, startDate: startDateBehaviorRelay.value, endDate: endDateBehaviorRelay.value, taskState: 0, categoryId : categoryListBehaviorRelay.value[selectedCategoryIndex.value].id)
        
        let startNotiID = Date().getCurrentMilliSec()
        let endNotiID = Date().getCurrentMilliSec() + "2"
        
        let noti = NotificationVO(id: Date().getCurrentMilliSec(), startNotificationID: startNotiID, endNotificationID: endNotiID, taskID: task.id!)
        
        if isRemaindMeBehaviorRelay.value {
            NotificationProvider.shared.addNotificationRequestToDevice(task: task, noti: noti)
            TaskProvider.shared.addTaskToFireStore(task: task)
            NotificationProvider.shared.addNotificationToFireStore(noti: noti)
        }
    }
}

extension CreateNewTaskViewModel {
    
    func didSelectTime(startTime : Date , endTime : Date){
        startDateBehaviorRelay.accept(startTime)
        endDateBehaviorRelay.accept(endTime)
    }
    
    func didSelectDate(selectedDate: Date) {
        let startDate = Date.from(year: selectedDate.getCurrentYear(), month: selectedDate.getCurrentMonth(), day: selectedDate.getCurrentDay(), hour: startDateBehaviorRelay.value.getCurrentHour(), minute: startDateBehaviorRelay.value.getCurrentMinute())
        let endDate = Date.from(year: selectedDate.getCurrentYear(), month: selectedDate.getCurrentMonth(), day: selectedDate.getCurrentDay(), hour: endDateBehaviorRelay.value.getCurrentHour(), minute: endDateBehaviorRelay.value.getCurrentMinute())
        startDateBehaviorRelay.accept(startDate)
        endDateBehaviorRelay.accept(endDate)
    }
}
