//
//  NotificationProvider.swift
//  To-Do
//
//  Created by sawpyaehtun on 14/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore
import CoreData

class NotificationProvider {
    let COLLECTION_PATH = "Notification"
    let TASK_ID = "taskID"
    var notificationList : [NotificationVO] = []
    static let shared = NotificationProvider()
}

extension NotificationProvider {
    
    func getNotiByKey() {
        guard let userIDForDocument = UserProvider.shared.getUserIDForDocumentFromDefault() else {
                   return
               }
        GoogleFirebaseDBManager().getDataFromFireStoreDocument(collectionPath: COLLECTION_PATH, documentName: userIDForDocument, keys: [""])
    }
    
    func getAllNotiFromFireStore() -> Observable<[NotificationVO]> {
        if NetworkManager.checkReachable() {
            guard let userIDForDocument = UserProvider.shared.getUserIDForDocumentFromDefault() else {
                return Observable.just([])
            }
            
            return GoogleFirebaseDBManager().getDataFromFireStoreDocument(collectionPath: COLLECTION_PATH, documentName: userIDForDocument).map{ (docSanpShot) -> [NotificationVO] in
                var notificationList : [NotificationVO] = []
                guard let docSnap = docSanpShot as? DocumentSnapshot,let data = docSnap.data() else {return []}
                for hh in data {
                    if let dic = hh.value as? [String : Any] {
                        notificationList.append(NotificationVO(dictionary: dic)!)
                    }
                }
                return notificationList
            }
        }
        
        getNotificationListFromCoreData { (notiList) in
            self.notificationList = notiList
        }
        
        return Observable.just(notificationList)
    }
    
    func addNotificationToFireStore(noti : NotificationVO){
        guard let userIDForDocument = UserProvider.shared.getUserIDForDocumentFromDefault() else {return}
        GoogleFirebaseDBManager().setDataToDocument(collectionPath: COLLECTION_PATH, documentName: userIDForDocument, key: noti.id, data: noti.toDictionary())
    }
    
    func addNotificationRequestToDevice(task : TaskVO , noti : NotificationVO) {
        LocalNotificationManager.shared.addRequestNotificationForStartTask(body: task.title!, date: task.startDate!, identifier: noti.startNotificationID ?? "")
                   
        LocalNotificationManager.shared.addRequestNotificationForEndTask(body: task.title!, date: task.endDate!, identifier: noti.endNotificationID ?? "")
    }
}

//MARK:- CORE DATA
extension NotificationProvider {
    func addToCoreData(notificationVO : NotificationVO) {
        _ = notificationVO.toNotificationCDVO()
        PersistenceManager.shared.saveContext()
    }
    
    func addToCoreData(notificationVOList : [NotificationVO]) {
        notificationVOList.forEach { (notificationVO) in
            addToCoreData(notificationVO: notificationVO)
        }
    }
    
    func getNotificationListFromCoreData(success : @escaping ([NotificationVO]) -> Void) {
        guard let notificationCDVOs = PersistenceManager.shared.getData(classType: ClassType.NotificationCDVO) as? [NotificationCDVO] else {return}
        success(notificationCDVOs.toNotificationVOs())
    }
    
    func getNotificationByIdFromCoreData(notificationID : String) -> NotificationVO? {
        let fetchRequest : NSFetchRequest<NotificationCDVO> = NotificationCDVO.fetchRequest()
        let predicate = NSPredicate(format: "id == %d", notificationID)
        fetchRequest.predicate = predicate
        
        do {
            let data = try PersistenceManager.shared.persistanceContainer.viewContext.fetch(fetchRequest)
            if data.isEmpty {
                return nil
            }
            return data[0].toNotificationVO()
        } catch {
            print("failed to fetch movie genre vo \(error.localizedDescription)")
            return nil
        }
        
    }
}
