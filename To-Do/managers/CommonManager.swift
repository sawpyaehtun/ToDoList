//
//  CommonManager.swift
//  MovieAsignWithRealm
//
//  Created by saw pyaehtun on 07/10/2019.
//  Copyright © 2019 saw pyaehtun. All rights reserved.
//

import Foundation

class CommonManger {
    static let shared = CommonManger()
//    static let ACCESS_TOKEN = "accessToken"
    static let IS_USER_LOGIN = "isUserLogin"
    static let USER_ID = "userID"
    static let IS_USER_FIRST_TIME_LOGIN = "isUserFirstTimeLogin"
    
    //MARK:- NSUserDefaults
    func saveBoolToNSUserDefault(value: Bool, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func retrieveBoolFromNSUserDefault(key:String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    func saveStringToNSUserDefault(value: String, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func saveObjectToNSUserDefault(value: Any, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func retrieveStringFromNSUserDefault(key: String) -> String {
        return UserDefaults.standard.string(forKey: key) ?? ""
    }
    
    func retrieveObjectFromNSUserDefault(key:String) -> Any {
        return UserDefaults.standard.object(forKey: key) as Any
    }
    
}

extension CommonManger {
    func isUserLogin () -> Bool{
        return retrieveBoolFromNSUserDefault(key: CommonManger.IS_USER_LOGIN)
    }
    
//    func getUserAccountDetail() -> AccountDetailVO? {
//        if let accountDetail = retrieveObjectFromNSUserDefault(key: CommonManger.ACCOUNT_DETAIL) as? Data{
//            if let accountDetailVO = accountDetail.decode(modelType: AccountDetailVO.self) {
//            return accountDetailVO
//            } else {
//                return nil
//            }
//        }else {return nil}
//    }
}
