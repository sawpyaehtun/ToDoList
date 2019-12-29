//
//  CircleView.swift
//  To-Do
//
//  Created by sawpyaehtun on 08/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable // to show in storyBoard
class CircleView : UIView {
    
    override func layoutSubviews() {
        layer.cornerRadius = self.bounds.height / 2
    }
}
