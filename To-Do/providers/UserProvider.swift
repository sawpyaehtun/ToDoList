//
//  UserProvider.swift
//  To-Do
//
//  Created by sawpyaehtun on 13/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore

class UserProvider {
    let COLLECTION_PATH = "User"
    let USER_EMAIL = "email"
    static let shared = UserProvider()
}

extension UserProvider {
    
    
    func saveUserIDForDocumentFromDefault(userIDForDocument : String) {
        CommonManger.shared.saveStringToNSUserDefault(value: userIDForDocument, key: CommonManger.USER_ID)
    }
    
    func getUserIDForDocumentFromDefault() -> String? {
        CommonManger.shared.retrieveStringFromNSUserDefault(key: CommonManger.USER_ID)
    }
    
    func saveUserLoginState(isUerLogin : Bool) {
        CommonManger.shared.saveBoolToNSUserDefault(value: isUerLogin, key: CommonManger.IS_USER_LOGIN)
    }
    
    func getUserLoginState() -> Bool? {
        return CommonManger.shared.retrieveBoolFromNSUserDefault(key: CommonManger.IS_USER_LOGIN)
    }
    
}
