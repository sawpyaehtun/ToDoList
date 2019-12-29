//
//  TaskViewBackgroundOfWeekView.swift
//  To-Do
//
//  Created by sawpyaehtun on 18/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation
import UIKit

class TaskViewBackgroundOfWeekView: UIView {
    override init(frame: CGRect) {
           super.init(frame: frame)
           self.commonInitialization()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           self.commonInitialization()
       }
       
       func commonInitialization() {
           let view = Bundle.main.loadNibNamed(String(describing: TaskViewBackgroundOfWeekView.self), owner: self, options: nil)?.first as! UIView
           view.frame = self.bounds
           self.addSubview(view)
       }
}
