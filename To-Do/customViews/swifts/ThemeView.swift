//
//  ThemeView.swift
//  To-Do
//
//  Created by sawpyaehtun on 13/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import UIKit

class ThemeView: UIView {
    
    @IBOutlet weak var viewPrimaryColor: CardView!
    @IBOutlet weak var viewSecondaryColor: CardView!
    @IBOutlet weak var viewSelectedBtn: CategoryView!
    @IBOutlet weak var viewUnselectedBtn: CategoryView!
    @IBOutlet weak var viewThemeViewBackground: CardView!
    
    var categoryName = ""
    
    var theme: themes? {
        didSet {
            viewSelectedBtn.category = theme?.getCategory(name: categoryName)
            viewSelectedBtn.isSelected = true
            
            viewUnselectedBtn.category = theme?.getCategory(name: categoryName)
            viewUnselectedBtn.isSelected = false
            
            viewPrimaryColor.backgroundColor = theme?.getBackGroundColor()
            viewSecondaryColor.backgroundColor = theme?.getShadowColor()
        }
    }
    
    var isSelectedIndex : Bool = false {
        didSet {
            viewThemeViewBackground.borderWidth = isSelectedIndex ? 2 : 0
        }
    }
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           self.commonInitialization()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           self.commonInitialization()
       }
       
       func commonInitialization() {
           let view = Bundle.main.loadNibNamed(String(describing: ThemeView.self), owner: self, options: nil)?.first as! UIView
           view.frame = self.bounds
           self.addSubview(view)
       }
    
    func isSelectedOrNot(isSelected : Bool) {
        
    }
}
