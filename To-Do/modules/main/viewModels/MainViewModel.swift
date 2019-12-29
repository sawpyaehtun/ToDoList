//
//  MainViewModel.swift
//  To-Do
//
//  Created by sawpyaehtun on 13/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import FBSDKLoginKit
import GoogleSignIn
import FirebaseAuth

class MainViewModel: BaseViewModel {
    let allTaskListBehaviorRelay = BehaviorRelay<[TaskVO]>(value: [])
    let selectedIndexInCategoryListBehaviorRelay = BehaviorRelay<Int>(value: 0)
    
    let categoryListBehaviorRelay = BehaviorRelay<[CategoryVO]>(value: [])
    
    let isEmptyTaskBehaviorRealy = BehaviorRelay<Bool>(value: false)
    
    let tfcategoryTitleBehaviorRealy = BehaviorRelay<String>(value: "")
    
    let isSuccessLogoutBehaviorRelay = BehaviorRelay<Bool>(value: false)
    
    var isDoneBtnEnable : Observable<Bool>{
        return tfcategoryTitleBehaviorRealy.map { (txt) -> Bool in
            !txt.isEmpty
        }
    }
    
    var taskListB4Current = BehaviorRelay<[TaskVO]>(value: [])
    
    let titleCategoryOfTaskBehaviorRealy = BehaviorRelay<String>(value: "")
    
    var taskListFilteredByCategoryObserable : Observable<[TaskVO]> {
        return Observable.combineLatest(selectedIndexInCategoryListBehaviorRelay.asObservable(),allTaskListBehaviorRelay.asObservable(),categoryListBehaviorRelay.asObservable()){ index, taskList, categoryList in
            if !categoryList.isEmpty {
                self.titleCategoryOfTaskBehaviorRealy.accept(self.categoryListBehaviorRelay.value[index].name ?? "")
                if !taskList.isEmpty {
                    return taskList.filter { (task) -> Bool in
                        task.categoryId == categoryList[index].id
                    }.sorted(by: { Int($0.id ?? "0")! < Int($1.id ?? "0")! })
                } else {
                    return []
                }
                
            } else {
                return []
            }
        }
    }
    
    override init() {
        super.init()
        LocalNotificationManager.shared.clearBadge()
    }
}


extension MainViewModel {
    func updateCtegory(){
        if titleCategoryOfTaskBehaviorRealy.value != tfcategoryTitleBehaviorRealy.value{
            loadingObservable.accept(true)
            let catID = categoryListBehaviorRelay.value[selectedIndexInCategoryListBehaviorRelay.value].id
            let catName = tfcategoryTitleBehaviorRealy.value
            let catTheme = categoryListBehaviorRelay.value[selectedIndexInCategoryListBehaviorRelay.value].theme
            
            let category = CategoryVO(id: catID, name: catName, theme: catTheme)
            CategoryProvider.shared.updateCategoryInFireStore(category: category) {
                self.loadingObservable.accept(false)
                self.getAllCategory()
            }
        }
    }
    
    func updteTask(task : TaskVO){
        TaskProvider.shared.updateTaskInFireStore(task: task, success: nil)
    }
    
    func delteTask(taskId : String){
        loadingObservable.accept(true)
        TaskProvider.shared.deleteTaskFromFireStore(taskID: taskId) {
            self.getAllTask()
        }
    }
    
    func getAllCategory(){
        loadingObservable.accept(true)
        CategoryProvider.shared.getAllCategoriesFromFireStoreDocument().subscribe(onNext: { (categoryList) in
            self.loadingObservable.accept(false)
            if categoryList.isEmpty {
                let category = CategoryVO(id: Date().getCurrentMilliSec(), name: "Work", theme: themes.purple.rawValue)
                CategoryProvider.shared.addCategoryToFireStore(category: category)
                self.getAllCategory()
            } else {
                let sortedCategoryList = categoryList.sorted(by: { Int($0.id ?? "0")! < Int($1.id ?? "0")! })
                self.categoryListBehaviorRelay.accept(sortedCategoryList)
            }
        }, onError: { (error) in
            self.errorObservable.accept(error.localizedDescription)
        }).disposed(by: disposableBag)
    }
    
    func getAllTask(){
        loadingObservable.accept(true)
        TaskProvider.shared.getAllTaskFromFireStore().subscribe(onNext: { (taskList) in
            self.loadingObservable.accept(false)
            if taskList.isEmpty {
                self.isEmptyTaskBehaviorRealy.accept(true)
            } else {
                
                let date = Date()
                
                let tasksb4current = taskList.filter { (task) -> Bool in
                    task.endDate! < date && task.taskState == TaskState.normal.rawValue
                }
                
                if tasksb4current.isEmpty {
                    self.allTaskListBehaviorRelay.accept(taskList)
                } else {
                    self.taskListB4Current.accept(tasksb4current)
                }
                
            }
        }, onError: { (error) in
            self.errorObservable.accept(error.localizedDescription)
        }).disposed(by: disposableBag)
    }
    
    func logout() {
        
        let loginManager = LoginManager()
        loginManager.logOut()
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        UserProvider.shared.saveUserLoginState(isUerLogin: false)
        isSuccessLogoutBehaviorRelay.accept(true)
        
    }
    
    
}
