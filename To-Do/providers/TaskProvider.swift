//
//  TaskProvider.swift
//  To-Do
//
//  Created by sawpyaehtun on 13/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore
import CoreData

class TaskProvider {
    let COLLECTION_PATH = "Task"
    static let shared = TaskProvider()
    var taskList : [TaskVO] = []
    init() {
        
    }
    
}

extension TaskProvider {
    
    
    func updateTaskInFireStore(task : TaskVO, success : (() -> ())?) {
        guard let userIDForDocument = UserProvider.shared.getUserIDForDocumentFromDefault() else {return}
        GoogleFirebaseDBManager().updateDocumentData(collectionPath: COLLECTION_PATH, documentName: userIDForDocument, key: task.id ?? "", data: task.toDictionary()) {
            print("SuccessFully updateed task . . .")
            if let completionHandlar = success {
                completionHandlar()
            }        }
    }
    
    func deleteTaskFromFireStore(taskID : String, success : @escaping () -> Void){
        guard let userIDForDocument = UserProvider.shared.getUserIDForDocumentFromDefault() else {return}
        GoogleFirebaseDBManager().deleteDocumentData(collectionPath: COLLECTION_PATH, documentName: userIDForDocument, key: taskID) {
            success()
        }
    }
    
    func getAllTaskFromFireStore() -> Observable<[TaskVO]> {
        if NetworkManager.checkReachable(){
            guard let userIDForDocument = UserProvider.shared.getUserIDForDocumentFromDefault() else {
                return Observable.just([])
            }
            return GoogleFirebaseDBManager().getDataFromFireStoreDocument(collectionPath: COLLECTION_PATH, documentName: userIDForDocument).map{ (docSanpShot) -> [TaskVO] in
                var taskList : [TaskVO] = []
                guard let docSnap = docSanpShot as? DocumentSnapshot,let data = docSnap.data() else {return []}
                for hh in data {
                    if let dic = hh.value as? [String : Any] {
                        taskList.append(TaskVO(dictionary: dic)!)
                    }
                }
                if !taskList.isEmpty{
                    self.addToCoreData(taskVOList: taskList)
                }
                return taskList
            }
        }
        
        getTaskListFromCoreData { (taskList) in
            self.taskList = taskList
        }
        
        return Observable.just(taskList)
    }
    
    func addTaskToFireStore(task : TaskVO){
        guard let userIDForDocument = UserProvider.shared.getUserIDForDocumentFromDefault() else {return}
        GoogleFirebaseDBManager().setDataToDocument(collectionPath: COLLECTION_PATH, documentName: userIDForDocument, key: task.id!, data: task.toDictionary())
    }
    
}

//MARK:- CORE DATA
extension TaskProvider {
    func addToCoreData(taskVO : TaskVO) {
        _ = taskVO.toTaskCDVO()
        PersistenceManager.shared.saveContext()
    }
    
    func addToCoreData(taskVOList : [TaskVO]) {
        taskVOList.forEach { (taskVO) in
            addToCoreData(taskVO: taskVO)
        }
    }
    
    func getTaskListFromCoreData(success : @escaping ([TaskVO]) -> Void) {
        guard let taskCDVOs = PersistenceManager.shared.getData(classType: ClassType.TaskCDVO) as? [TaskCDVO] else {return}
        success(taskCDVOs.toTaskVOs())
    }
    
    func getTaskByIdFromCoreData(taskID : String) -> TaskVO? {
        let fetchRequest : NSFetchRequest<TaskCDVO> = TaskCDVO.fetchRequest()
        let predicate = NSPredicate(format: "id == %d", taskID)
        fetchRequest.predicate = predicate
        
        do {
            let data = try PersistenceManager.shared.persistanceContainer.viewContext.fetch(fetchRequest)
            if data.isEmpty {
                return nil
            }
            return data[0].toTaskVO()
        } catch {
            print("failed to fetch movie genre vo \(error.localizedDescription)")
            return nil
        }
        
    }
}
