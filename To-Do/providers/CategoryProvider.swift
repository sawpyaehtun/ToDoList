//
//  CategoryProvider.swift
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

class CategoryProvider {
    let COLLECTION_PATH = "Category"
    var categoryList : [CategoryVO] = []
    static let shared = CategoryProvider()
}

extension CategoryProvider {

    func getAllCategoriesFromFireStoreDocument() -> Observable<[CategoryVO]>{
        if NetworkManager.checkReachable() {
            guard let userIDForDocument = UserProvider.shared.getUserIDForDocumentFromDefault() else {
                return Observable.just([])
            }
            return GoogleFirebaseDBManager().getDataFromFireStoreDocument(collectionPath: COLLECTION_PATH, documentName: userIDForDocument).map { (docSanpShot) -> [CategoryVO] in
                var categoryList : [CategoryVO] = []
                guard let docSnap = docSanpShot as? DocumentSnapshot,let data = docSnap.data() else {return []}
                for hh in data {
                    if let dic = hh.value as? [String : Any] {
                        if let category = CategoryVO(dictionary: dic){
                            categoryList.append(category)
                        }
                    }
                }
                if !categoryList.isEmpty {
                    self.addToCoreData(categoryVOList: categoryList)
                }
                return categoryList
            }
        }
        
        getCategoryListFromCoreData { (categoryList) in
            self.categoryList = categoryList
        }
        return Observable.just(categoryList)
    }
    
    func updateCategoryInFireStore(category : CategoryVO, success : @escaping () -> Void) {
        guard let userIDForDocument = UserProvider.shared.getUserIDForDocumentFromDefault() else {return}
        GoogleFirebaseDBManager().updateDocumentData(collectionPath: COLLECTION_PATH, documentName: userIDForDocument, key: category.id!, data: category.toDictionary()) {
            success()
        }
    }
    
    func addCategoryToFireStore(category : CategoryVO){
        guard let userIDForDocument = UserProvider.shared.getUserIDForDocumentFromDefault() else {return}
        GoogleFirebaseDBManager().setDataToDocument(collectionPath: COLLECTION_PATH, documentName: userIDForDocument, key: category.id!, data: category.toDictionary())
    }
}

//MARK:- CORE DATA
extension CategoryProvider {
    func addToCoreData(categoryVO : CategoryVO) {
        _ = categoryVO.toCategoryCDVO()
        PersistenceManager.shared.saveContext()
    }
    
    func addToCoreData(categoryVOList : [CategoryVO]) {
        categoryVOList.forEach { (categoryVO) in
            addToCoreData(categoryVO: categoryVO)
        }
    }
    
    func getCategoryListFromCoreData(success : @escaping ([CategoryVO]) -> Void) {
        guard let categoryCDVOs = PersistenceManager.shared.getData(classType: ClassType.CategoryCDVO) as? [CategoryCDVO] else {return}
        success(categoryCDVOs.toCategoryVOs())
    }
    
    func getCategoryByIdFromCoreData(categoryID : String) -> CategoryVO? {
        let fetchRequest : NSFetchRequest<CategoryCDVO> = CategoryCDVO.fetchRequest()
        let predicate = NSPredicate(format: "id == %d", categoryID)
        fetchRequest.predicate = predicate
        
        do {
            let data = try PersistenceManager.shared.persistanceContainer.viewContext.fetch(fetchRequest)
            if data.isEmpty {
                return nil
            }
            return data[0].toCategoryVO()
        } catch {
            print("failed to fetch movie genre vo \(error.localizedDescription)")
            return nil
        }
        
    }
}
