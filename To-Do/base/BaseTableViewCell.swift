//
//  BaseTableViewCell.swift
//  Haulio
//
//  Created by Duy Nguyen on 8/3/18.
//  Copyright © 2018 Haulio Pte Ltd. All rights reserved.
//

import UIKit
import RxSwift

class BaseTableViewCell: UITableViewCell {
    
    let disposableBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUIs()
        applyTheme()
        setupTest()
        bindData()
    }
    
    func setupUIs() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        applyTheme()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
 
    func applyTheme(){
        selectionStyle = .none
    }
    
    func setupTest() {
        
    }
    
    func bindData() {
        
    }
}
