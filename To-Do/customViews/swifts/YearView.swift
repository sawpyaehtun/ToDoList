//
//  YearView.swift
//  To-Do
//
//  Created by sawpyaehtun on 10/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import UIKit

class YearView: UIView {

    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var viewYearBg: CardView!
    
    var id : Int?
    var year : Int?
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           self.commonInitialization()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           self.commonInitialization()
       }
       
       func commonInitialization() {
           let view = Bundle.main.loadNibNamed(String(describing: YearView.self), owner: self, options: nil)?.first as! UIView
           view.frame = self.bounds
           self.addSubview(view)
       }
    
    func isSelectedOrNot(isSelected : Bool) {
        viewYearBg.borderColor = isSelected ? UIColor.lightGray : UIColor.clear
    }
    
}
