//
//  SnapShotCellForWeekView.swift
//  To-Do
//
//  Created by sawpyaehtun on 19/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation
import UIKit

class SnapShotCellForWeekView: UIView {
    
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var viewSnapShot: UIView!
    
    var hour : Int = 0{
        didSet {
            lblStartTime.text = String(format: "%02d", hour) + " : " + String(format: "%02d", minutes)
        }
    }
    
    var minutes : Int = 00 {
        didSet{
            lblStartTime.text = String(format: "%02d", hour) + " : " + String(format: "%02d", minutes)
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
        let view = Bundle.main.loadNibNamed(String(describing: SnapShotCellForWeekView.self), owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
}
