
//
//  BaseModel.swift
//  HouseListApp
//
//  Created by saw pyaehtun on 12/09/2019.
//  Copyright © 2019 saw pyaehtun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel {
    let disposableBag = DisposeBag()
    
    var viewController : BaseViewController?
    var errorObservable = BehaviorRelay<String?>(value: nil)
    var loadingObservable = BehaviorRelay<Bool>(value: false)
    var isGifLoadingView = false
    
    init() {
        
    }
    deinit {
        debugPrint("Deinit \(type(of: self))")
    }
    
    func bindViewModel(in viewController: BaseViewController?) {
        
        self.viewController = viewController
        
        errorObservable.subscribe(onNext: { (error) in
            viewController?.hideLoading()
            if let error = error, !error.isEmpty {
                 AlertManager.showCommonError(message: error, vc: viewController!)
            }
        }).disposed(by: disposableBag)
        
        loadingObservable.subscribe(onNext: { (result) in
            
                if result {
                    viewController?.showLoading()
                } else {
                    viewController?.hideLoading()
                }
            
        }).disposed(by: disposableBag)
    }
}
