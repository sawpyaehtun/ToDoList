//
//  PersistanceManager.swift
//  contact-core-date
//
//  Created by saw pyaehtun on 22/09/2019.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum ClassType : String {
    case TaskCDVO
    case CategoryCDVO
    case NotificationCDVO
}

final class PersistenceManager {
    
    static let shared = PersistenceManager()
    
    private init(){}
    
    var persistanceContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    func getData(classType : ClassType) -> [Any]{
        
        do {
            switch classType {
            case .TaskCDVO:
                let results = try persistanceContainer.viewContext.fetch(TaskCDVO.fetchRequest())
                print(results.count)
                return results
            case .CategoryCDVO:
                let results = try persistanceContainer.viewContext.fetch(CategoryCDVO.fetchRequest())
                print(results.count)
                return results
            case .NotificationCDVO:
                let results = try persistanceContainer.viewContext.fetch(NotificationCDVO.fetchRequest())
                print(results.count)
                return results
            }
        } catch let err{
            print("core data fetching error \(err.localizedDescription)")
        }
        
        return []
    }
    
    func saveContext() {
        let context = persistanceContainer.viewContext
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        if context.hasChanges {
            do {
                try context.save()
                print("successfylly saved . . .")
            } catch let coredataError {
                print("coredataError while saving \(coredataError.localizedDescription)")
            }
        }
    }
}
