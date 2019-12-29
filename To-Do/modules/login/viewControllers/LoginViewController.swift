//
//  ViewController.swift
//  To-Do
//
//  Created by Ye Ko Ko Htet on 07/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import RxCocoa
import RxSwift

class LoginViewController: BaseViewController {
    
    static let FACEBOOK_PROFILE_NAME = "name"
    static let FACEBOOK_PROFILE_PIC = "picture"
    static let FACEBOOK_USER_EMAIL = "email"
    
    
    @IBOutlet weak var viewFaceBookLogin: CardView!
    @IBOutlet weak var viewGoogleLogin: CardView!
    @IBOutlet weak var lblList: UILabel!
    @IBOutlet weak var lblToDo: UILabel!
    @IBOutlet weak var lblBlueCircle: UILabel!
    @IBOutlet weak var lblMaroonCircle: UILabel!
    @IBOutlet weak var lblYellowCircle: UILabel!
    @IBOutlet weak var btnDefaultFBLoginButton: FBLoginButton!
    @IBOutlet weak var btnDefaultGoogleLoginButton: GIDSignInButton!
    
    @IBOutlet weak var viewCircleYellow: CircleView!
    @IBOutlet weak var imgThreeCircle: UIImageView!
    @IBOutlet weak var viewCircleMaroon: CircleView!
    @IBOutlet weak var viewCircleBlue: CircleView!
    
    let viewModel : LoginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prePareUIForAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        let vc = TestViewController.init()
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true, completion: nil)

        if viewModel.isUSerLogin() {
            goToMain()
        }
        
        super.viewDidAppear(animated)
        startAnimation()
    }
    
    override func setUpUIs() {
        super.setUpUIs()
//        let layoutConstraintsArr = btnDefaultFBLoginButton.constraints
//        // Iterate over array and test constraints until we find the correct one:
//        for lc in layoutConstraintsArr { // or attribute is NSLayoutAttributeHeight etc.
//            if ( lc.constant == 28 ){
//                // Then disable it...
//                lc.isActive = false
//                break
//            }
//        }
        
        btnDefaultFBLoginButton.permissions = ["email"]
        btnDefaultFBLoginButton.delegate = self
    }
    
    private func prePareUIForAnimation() {
        lblToDo.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        lblList.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        lblToDo.alpha = 0.0
        lblList.alpha = 0.0
        
        imgThreeCircle.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        imgThreeCircle.alpha = 0.0
        
        lblBlueCircle.alpha = 0.0
        lblYellowCircle.alpha = 0.0
        lblMaroonCircle.alpha = 0.0
        
        viewCircleYellow.alpha = 0.0
        viewCircleMaroon.alpha = 0.0
        viewCircleBlue.alpha = 0.0
        
        lblBlueCircle.center.x -= 24
        lblYellowCircle.center.x -= 24
        lblMaroonCircle.center.x -= 24
        
        viewGoogleLogin.alpha = 0.0
        viewFaceBookLogin.alpha = 0.0
        
        viewGoogleLogin.center.y += 48
        viewFaceBookLogin.center.y += 48
    }
    
    private func startAnimation(){
        
        UIView.animate(withDuration: 1.0) {
            self.lblToDo.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.lblList.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.lblToDo.alpha = 1.0
            self.lblList.alpha = 1.0
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.3, options: .curveEaseInOut, animations: {
            self.viewCircleYellow.alpha = 1.0
        }, completion: nil)
        
        
        UIView.animate(withDuration: 1,delay: 0.3, animations: {
            self.lblYellowCircle.center.x += 24
            self.lblYellowCircle.alpha = 1.0
        }) { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                self.lblYellowCircle.center.x += 48
                self.lblYellowCircle.alpha = 0.0
            }) { (_) in
                self.viewCircleYellow.startAnimationMoveCurve(fromPoint: self.viewCircleYellow.center, toPoint: self.imgThreeCircle.center, delayTime: 0, duration: 1, completionHandler: nil)
                self.viewCircleMaroon.startAnimationMoveCurve(fromPoint: self.viewCircleMaroon.center, toPoint: self.imgThreeCircle.center, delayTime: 0.3, duration: 1, completionHandler: nil)
                self.viewCircleBlue.startAnimationMoveCurve(fromPoint: self.viewCircleBlue.center, toPoint: self.imgThreeCircle.center, delayTime: 0.6, duration: 1){
                    UIView.animate(withDuration: 0.4, animations: {
                        self.viewCircleYellow.alpha = 0.0
                        self.viewCircleMaroon.alpha = 0.0
                        self.viewCircleBlue.alpha = 0.0
                        self.imgThreeCircle.alpha = 1.0
                    }) { (isCompleted) in
                        if isCompleted {
                            let rotateImgThreeCircle = AnimationManager.shared.rotateAnimation(angle: 360, duration: 1)
                            let scaleImageThreeCircle = AnimationManager.shared.scaleAnimation(fromValue: 0.05, toValue: 1, duration: 1)
                            let rotateAndScaleImgThreeCircle = AnimationManager.shared.groupAnimation(animations: [scaleImageThreeCircle,rotateImgThreeCircle], delay: 0, duration: 1)
                            self.imgThreeCircle.layer.add(rotateAndScaleImgThreeCircle, forKey: "nil")
                        }
                    }
                }
            }
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.6, options: .curveEaseInOut, animations: {
            self.viewCircleMaroon.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0.6, options: .curveEaseInOut, animations: {
            self.lblMaroonCircle.center.x += 24
            self.lblMaroonCircle.alpha = 1.0
        }) { (_) in
            UIView.animate(withDuration: 0.5){
                self.lblMaroonCircle.center.x += 48
                self.lblMaroonCircle.alpha = 0.0
            }
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.9, options: .curveEaseInOut, animations: {
            self.viewCircleBlue.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0.9, options: .curveEaseInOut, animations: {
            self.lblBlueCircle.center.x += 24
            self.lblBlueCircle.alpha = 1.0
        }) { (_) in
            UIView.animate(withDuration: 0.5){
                self.lblBlueCircle.center.x += 48
                self.lblBlueCircle.alpha = 0.0
            }
        }
        
        
        UIView.animate(withDuration: 1.4, delay: 4, animations: {
            self.viewFaceBookLogin.alpha = 1.0
            self.viewFaceBookLogin.center.y -= 48
        }, completion: nil)
        
        UIView.animate(withDuration: 1.4, delay: 4.5, animations: {
            self.viewGoogleLogin.alpha = 1.0
            self.viewGoogleLogin.center.y -= 48
        }, completion: { (isSuccessed) in
            if isSuccessed {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (didAllow, error) in
                }
            }
        })
    }
    
    func getScale(for t: CGAffineTransform) -> CGFloat {
        return sqrt(t.a * t.a + t.c * t.c)
    }
    
    override func bindModel() {
        super.bindModel()
        viewModel.bindViewModel(in: self)
    }
    
    override func bindData() {
        super.bindData()
        viewModel.isUserLoginSuccessBehaviorRelay.subscribe(onNext: { (isUserLogin) in
            if isUserLogin {
                self.goToMain()
            }
        }).disposed(by: disposableBag)
    }
    
    
}

// user interaction
extension LoginViewController {
    
    @IBAction func didTapBtnGoogleLogin(_ sender: Any) {
        showLoading()
        btnDefaultGoogleLoginButton.sendActions(for: .touchUpInside)
    }
    
    @IBAction func didTapBtnFBLogin(_ sender: Any) {
        showLoading()
        btnDefaultFBLoginButton.sendActions(for: .touchUpInside)
    }
    
}

// go to another Screen
extension LoginViewController {
    
    private func goToMain(){
        let vc = MainViewController.init()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
}

// faceBook Login delegate
extension LoginViewController : LoginButtonDelegate{
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        viewModel.didFBLogin(loginButton, didCompleteWith: result, error: error)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //        imgProfilePic.image = UIImage(named: "person.circle")
        //        lblUsername.text = "User Name"
    }
    
}

// google Login
extension LoginViewController : GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        viewModel.didGoogleLogin(signIn, didSignInFor: user, withError: error)
    }
    
}



