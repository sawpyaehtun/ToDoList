//
//  CreateCategoryViewModel.swift
//  To-Do
//
//  Created by sawpyaehtun on 13/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CreateCategoryViewModel: BaseViewModel {
    
    var themeListSelectedIndex = BehaviorRelay<Int>(value: 0)
    var themeListBehaviorRelay = BehaviorRelay<[CategoryVO]>(value: [])
    var categoryName = BehaviorRelay<String>(value: "")
    
    var isEnableCreateCategory : Observable<Bool> {
        return categoryName.map { (text) -> Bool in
            !text.isEmpty
        }
    }     
    
    override init() {
        super.init()
        categoryName.subscribe(onNext: { (catName) in
            let themeList : [CategoryVO] = [CategoryVO(id: "", name: catName, theme: themes.purple.rawValue),
            CategoryVO(id: "", name: catName, theme: themes.yellow.rawValue),
            CategoryVO(id: "", name: catName, theme: themes.blue.rawValue),
            CategoryVO(id: "", name: catName, theme: themes.maroon.rawValue)]
            self.themeListBehaviorRelay.accept(themeList)
        }).disposed(by: disposableBag)
    }
    
}

extension CreateCategoryViewModel {
    func createCategory(){
        let category = CategoryVO(id: Date().getCurrentMilliSec(), name: categoryName.value, theme: themeListBehaviorRelay.value[themeListSelectedIndex.value].theme)
        CategoryProvider.shared.addCategoryToFireStore(category: category)
    }
}
