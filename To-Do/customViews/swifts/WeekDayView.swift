//
//  WeekDayView.swift
//  To-Do
//
//  Created by sawpyaehtun on 10/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import UIKit

class WeekDayView: UIView {
    
    @IBOutlet weak var lblWeekDay: UILabel!
    
    override init(frame: CGRect) {
              super.init(frame: frame)
              self.commonInitialization()
          }
          
          required init?(coder aDecoder: NSCoder) {
              super.init(coder: aDecoder)
              self.commonInitialization()
          }
          
          func commonInitialization() {
              let view = Bundle.main.loadNibNamed(String(describing: WeekDayView.self), owner: self, options: nil)?.first as! UIView
              view.frame = self.bounds
              self.addSubview(view)
          }
}
