//
//  BaseViewController.swift
//  HouseListApp
//
//  Created by saw pyaehtun on 12/09/2019.
//  Copyright © 2019 saw pyaehtun. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import RxSwift

class BaseViewController: UIViewController {
    
    let disposableBag = DisposeBag()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpUIs()
        bindData()
        bindModel()
        setUpAnimation()
    }
    
    func setUpNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func setUpAnimation(){
        
    }
    
    func setUpUIs() {
        
    }
    
    func bindData() {
        
    }
    
    func bindModel() {
        
    }
    
    func setUpRefreshControl() {
        refreshControl.backgroundColor = UIColor.black
        refreshControl.tintColor = UIColor.white
    }
    
    // Hide/Show status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func dismissThis(animated : Bool){
        dismiss(animated: animated, completion: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get{
            return .portrait
        }
    }
    
}

extension BaseViewController {
    
    func showAlertDialog(message : String) {
        let alert = UIAlertController(title: "Failed", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

// Note: this is for Loading View
extension BaseViewController : NVActivityIndicatorViewable {
    func showLoading(message : String = "") {
        startAnimating(CGSize(width: 30, height: 30), message: message, type: .audioEqualizer)
    }
    
    func hideLoading() {
        stopAnimating()
    }
}
