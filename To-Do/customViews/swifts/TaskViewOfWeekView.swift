//
//  TaskViewOfWeekView.swift
//  To-Do
//
//  Created by sawpyaehtun on 19/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation
import UIKit

class TaskViewOfWeekView: UIView {
    
    @IBOutlet weak var lblTaskTitle: UILabel!
    @IBOutlet var viewTaskViewBackground: CardView!
    
    
    var task : TaskVO? {
        didSet {
            lblTaskTitle.text = task?.title
        }
    }
    
    var taskTheme : String? {
        didSet {
            switch taskTheme {
            case themes.purple.rawValue:
                viewTaskViewBackground.backgroundColor = themes.purple.getBackGroundColor()
                viewTaskViewBackground.shadowColor = themes.purple.getShadowColor()
            case themes.yellow.rawValue:
                viewTaskViewBackground.backgroundColor = themes.yellow.getBackGroundColor()
                viewTaskViewBackground.shadowColor = themes.yellow.getShadowColor()
            case themes.blue.rawValue:
                viewTaskViewBackground.backgroundColor = themes.blue.getBackGroundColor()
                viewTaskViewBackground.shadowColor = themes.blue.getShadowColor()
            case themes.maroon.rawValue:
                viewTaskViewBackground.backgroundColor = themes.maroon.getBackGroundColor()
                viewTaskViewBackground.shadowColor = themes.maroon.getShadowColor()
            default:
                break
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
        let view = Bundle.main.loadNibNamed(String(describing: TaskViewOfWeekView.self), owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
}
