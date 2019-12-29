//
//  FireStorageManager.swift
//  FireStoreResturantSB
//
//  Created by saw pyaehtun on 24/10/2019.
//  Copyright © 2019 saw pyaehtun. All rights reserved.
//

import Foundation
import FirebaseStorage
import RxSwift
import RxCocoa

final class FireStorageManager {
    
    func upload(image : UIImage) -> Observable<String?>{
        let imageName = UUID().uuidString
        let imageRefrance = Storage.storage().reference().child("images").child(imageName)
        
        guard let data = image.jpegData(compressionQuality: 0.8) else {return Observable.just(nil)}
        
        return Observable.create { observer in
            
            imageRefrance.putData(data, metadata: nil) { (metaData, error) in
                if let error = error {
                    print(error.localizedDescription)
                    observer.onError(error)
                } else {
                    observer.onNext(imageName)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func downloadUrl(imageName : String) -> Observable<String>{
        let imageRefrance = Storage.storage().reference().child("images").child(imageName)
        
        return Observable.create { observer in
            imageRefrance.downloadURL { (url, error) in
                if let error = error {
                    print(error.localizedDescription)
                    observer.onError(error)
                } else {
                    observer.onNext(url!.absoluteString)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
        
    }
}
