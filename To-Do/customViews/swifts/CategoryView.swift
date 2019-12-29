//
//  CategoryView.swift
//  To-Do
//
//  Created by sawpyaehtun on 15/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation
import UIKit

class CategoryView: UIView {
    
    @IBOutlet weak var viewBackGround: CardView!
    @IBOutlet weak var lblCategorySymbol: UILabel!
    
    var category : CategoryVO? {
        didSet {
            lblCategorySymbol.text = category?.name!.prefix(1).capitalized
            switch category?.name {
            case themes.purple.rawValue:
                lblCategorySymbol.textColor = themes.purple.getBackGroundColor()
                viewBackGround.backgroundColor = UIColor(named: "btnDefaultBackGround")
            case themes.blue.rawValue:
                lblCategorySymbol.textColor = themes.blue.getBackGroundColor()
                viewBackGround.backgroundColor = UIColor(named: "btnDefaultBackGround")
            case themes.yellow.rawValue:
                lblCategorySymbol.textColor = themes.yellow.getBackGroundColor()
                viewBackGround.backgroundColor = UIColor(named: "btnDefaultBackGround")
            case themes.maroon.rawValue:
                lblCategorySymbol.textColor = themes.maroon.getBackGroundColor()
                viewBackGround.backgroundColor = UIColor(named: "btnDefaultBackGround")
            default:
                lblCategorySymbol.textColor = .white
                viewBackGround.backgroundColor = UIColor(named: "btnDefaultBackGround")
                viewBackGround.shadowColor = UIColor(named: "btnDefaultBackGroundShadow")
            }
        }
    }
    
    var isSelected : Bool?{
        didSet {
            switch category?.theme{
            case themes.purple.rawValue:
                lblCategorySymbol.textColor = isSelected! ? .white : themes.purple.getBackGroundColor()
                viewBackGround.backgroundColor = isSelected! ? themes.purple.getBackGroundColor() : UIColor(named: "btnDefaultBackGround")
                viewBackGround.shadowColor = isSelected! ? themes.purple.getShadowColor() : UIColor(named: "btnDefaultBackGroundShadow")
            case themes.blue.rawValue:
                lblCategorySymbol.textColor = isSelected! ? .white : themes.blue.getBackGroundColor()
                viewBackGround.backgroundColor = isSelected! ? themes.blue.getBackGroundColor() : UIColor(named: "btnDefaultBackGround")
                viewBackGround.shadowColor = isSelected! ? themes.blue.getShadowColor() : UIColor(named: "btnDefaultBackGroundShadow")
            case themes.yellow.rawValue:
                lblCategorySymbol.textColor = isSelected! ? .white : themes.yellow.getBackGroundColor()
                viewBackGround.backgroundColor = isSelected! ? themes.yellow.getBackGroundColor() : UIColor(named: "btnDefaultBackGround")
                viewBackGround.shadowColor = isSelected! ? themes.yellow.getShadowColor() : UIColor(named: "btnDefaultBackGroundShadow")
            case themes.maroon.rawValue:
                lblCategorySymbol.textColor = isSelected! ? .white : themes.maroon.getBackGroundColor()
                viewBackGround.backgroundColor = isSelected! ? themes.maroon.getBackGroundColor() : UIColor(named: "btnDefaultBackGround")
                viewBackGround.shadowColor = isSelected! ? themes.maroon.getShadowColor() : UIColor(named: "btnDefaultBackGroundShadow")
            default:
                lblCategorySymbol.textColor = .white
                viewBackGround.backgroundColor = UIColor(named: "btnDefaultBackGround")
                viewBackGround.shadowColor = UIColor(named: "btnDefaultBackGroundShadow")
            }
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
        let view = Bundle.main.loadNibNamed(String(describing: CategoryView.self), owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
}
