//
//  MonthViewDayItemCollectionViewCell.swift
//  To-Do
//
//  Created by sawpyaehtun on 18/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import UIKit
import SnapKit

class MonthViewDayItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var viewForCategory: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func setupItem(day : Date, themesArr : [themes]){
        viewForCategory.subviews.forEach({ $0.removeFromSuperview() })
        lblDay.text = "\(day.getCurrentDay())"
        
        let isPastMonth = day.getCurrentMonth() < Date().getCurrentMonth()
        let isPastDay = day.getCurrentDay() < Date().getCurrentDay()
        
        lblDay.isHidden = isPastMonth ? true : false
        lblDay.textColor = isPastDay ? .darkGray : .white
       
            if !isPastDay {
                setExistingCategories(themesArr: themesArr)
            }
        
    }
    
    private func setExistingCategories(themesArr : [themes]){
         
        var bottomConstraint = 2
        let intervalThemebar = 2
        let leading = 15
        let barHeight = 10
        //        print(barHeight)
        themesArr.forEach { (theme) in
            let themeBar = UIView()
            themeBar.layer.cornerRadius = 5
            themeBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            themeBar.backgroundColor = theme.getBackGroundColor()
            viewForCategory.addSubview(themeBar)
            
            themeBar.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview().inset(bottomConstraint)
                make.leading.equalToSuperview().inset(leading)
                make.trailing.equalToSuperview().inset(intervalThemebar)
                make.height.equalTo(barHeight)
            }
            
            bottomConstraint += intervalThemebar + Int(barHeight)
            
        }
    }
}
//}


