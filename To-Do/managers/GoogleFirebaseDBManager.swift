//
//  GoogleFirebaseDBManager.swift
//  FireStoreProject
//
//  Created by saw pyaehtun on 23/10/2019.
//  Copyright © 2019 saw pyaehtun. All rights reserved.
//

import Foundation
import FirebaseFirestore
import RxSwift
import RxCocoa
import SwiftyJSON

final class GoogleFirebaseDBManager {
    
    var listener : ListenerRegistration?
    
    var query : Query? {
        didSet {
            if let listener = listener {
                listener.remove()
            }
        }
    }
    
    let db = Firestore.firestore()
    
    private func baseQuery(collectionPath : String)-> Query{
        return Firestore.firestore().collection(collectionPath)
    }
    
    private func baseDocumentRef(collectionPath : String, documentName : String) -> DocumentReference {
        return Firestore.firestore().collection(collectionPath).document(documentName)
    }
    
    func getDataFromFireStore(collectionPath : String) -> Observable<Any?> {
        self.query = baseQuery(collectionPath: collectionPath)
        
        return Observable.create { observer in
            self.listener = self.query?.addSnapshotListener({ (querySnapshot, error) in
                if let err = error{
                    print(err.localizedDescription)
                    observer.onError(error!)
                } else{
                    observer.onNext(querySnapshot?.documents)
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        }
    }
    
    func getDataFromFireStoreDocument(collectionPath : String, documentName : String) -> Observable<Any?> {
        let documentRef = baseDocumentRef(collectionPath: collectionPath, documentName: documentName)
        
        return Observable.create { observer in
            documentRef.getDocument(completion: { (docSanpShot, error) in
                if let error = error {
                    print(error.localizedDescription)
                    observer.onError(error)
                } else {
                    observer.onNext(docSanpShot)
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        }
    }
    
    func getDataFromFireStoreDocument(collectionPath : String, documentName : String, keys : [String]) {
        let result = baseDocumentRef(collectionPath: collectionPath, documentName: documentName).dictionaryWithValues(forKeys: ["1576432840"])
        print(result)
    }
    
    func getDataFromFireStore(collectionPath : String, fieldname : String, value : String) -> Observable<Any?> {
        self.query = baseQuery(collectionPath: collectionPath)
        
        return Observable.create { observer in
            self.listener = self.query?.whereField(fieldname, isEqualTo: value).addSnapshotListener({ (querySnapshot, error) in
                if let err = error{
                    print(err.localizedDescription)
                    observer.onError(error!)
                } else{
                    observer.onNext(querySnapshot?.documents)
                    observer.onCompleted()
                }
            })
            
            return Disposables.create()
        }
    }
    
    func addData(collectionPath : String, data : [String : Any]) {
        db.collection(collectionPath).addDocument(data: data)
    }
    
    func setDataToDocument(collectionPath : String ,documentName : String, key : String,data : [String : Any]) {
        let keyValuePairedData = [key : data]
        print(data)
        db.collection(collectionPath).document(documentName).setData(keyValuePairedData, merge: true)
    }
    
    func updateDocumentData(collectionPath : String ,documentName : String, key : String,data : [String : Any], success : @escaping () -> Void) {
        let keyValuePairedData = [key : data]
        db.collection(collectionPath).document(documentName).updateData(keyValuePairedData){ err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                success()
            }
        }
    }
    
    func deleteDocumentData(collectionPath : String ,documentName : String, key : String, success : @escaping () -> Void) {
        let keyValuePairedData = [key : FieldValue.delete()]
        db.collection(collectionPath).document(documentName).updateData(keyValuePairedData){ err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                success()
            }
        }
    }
    
    func addDataAndGetID(collectionPath : String, data : [String : Any]) -> String{
        return db.collection(collectionPath).addDocument(data: data).documentID
    }
    
    func deleteData(collectionPath : String, id : String) {
        db.collection(collectionPath).document(id)
    }
}
