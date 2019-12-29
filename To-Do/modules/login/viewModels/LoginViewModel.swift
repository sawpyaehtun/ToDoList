//
//  LoginViewModel.swift
//  To-Do
//
//  Created by sawpyaehtun on 09/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import GoogleSignIn
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewModel: BaseViewModel {
    var isUserLoginSuccessBehaviorRelay = BehaviorRelay<Bool>(value: false)
    override init() {
        super.init()
    }
}

extension LoginViewModel {
    
    func login (userIDForDocument : String){
        UserProvider.shared.saveUserIDForDocumentFromDefault(userIDForDocument: userIDForDocument)
        UserProvider.shared.saveUserLoginState(isUerLogin: true)
        loadingObservable.accept(false)
        getAllCategory()
        isUserLoginSuccessBehaviorRelay.accept(true)
    }
    
    func isUSerLogin() -> Bool{
        if let isUserLogin = UserProvider.shared.getUserLoginState() {
            return isUserLogin
        } else {
            return false
        }
    }
    
    func getAllCategory(){
        loadingObservable.accept(true)
        CategoryProvider.shared.getAllCategoriesFromFireStoreDocument().subscribe(onNext: { (categoryList) in
            self.loadingObservable.accept(false)
            if categoryList.isEmpty {
                let category = CategoryVO(id: Date().getCurrentMilliSec(), name: "Work", theme: themes.purple.rawValue)
                CategoryProvider.shared.addCategoryToFireStore(category: category)
            }
        }, onError: { (error) in
            self.errorObservable.accept(error.localizedDescription)
        }).disposed(by: disposableBag)
    }
    
}

// facebook and Google login
extension LoginViewModel {
    func didFBLogin(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?){
        loadingObservable.accept(true)
        if result!.isCancelled {
            self.loadingObservable.accept(false)
            return
        }
        
        if error == nil {
            if result!.grantedPermissions.contains("email")
            {
                print("get permission")
            } else {
                print("permission denined")
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let userIDForDocument = authResult?.user.uid else {return}
                self.login(userIDForDocument: userIDForDocument)
            }
        } else {
            print(error?.localizedDescription as Any)
        }
    }
    
    func didGoogleLogin(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        loadingObservable.accept(true)
        if let error = error {
            self.loadingObservable.accept(false)
            print(error.localizedDescription)
            return
        }
        print("Success Login")
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                self.loadingObservable.accept(false)
            }
            
            guard let userIDForDocument = authResult?.user.uid else {return}
            self.login(userIDForDocument: userIDForDocument)
            
        }
    }
    
}
