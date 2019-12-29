//
//  CardView.swift
//  TableViewWithTabBar
//
//  Created by saw pyaehtun on 24/08/2019.
//  Copyright © 2019 saw pyaehtun. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable // to show in storyBoard
class CardView: UIView {
    @IBInspectable var cornerRadius : CGFloat = 2
    @IBInspectable var shadowCornerRaduis : CGFloat = 0
    @IBInspectable var shadowOffsetWidth : Int = 0
    @IBInspectable var shadowOffsetHeight : Int = 0
    @IBInspectable var shadowColor : UIColor? = UIColor.black
    @IBInspectable var shadowOpacity : Float = 0.5
    @IBInspectable var borderWidth :  CGFloat = 0.0
    @IBInspectable var borderColor :  UIColor? = UIColor.black
    @IBInspectable var showShadow : Bool = true
    
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
        
        if showShadow {
            let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: shadowCornerRaduis == 0 ? cornerRadius : shadowCornerRaduis)
            
            layer.masksToBounds = false
            layer.shadowColor = shadowColor?.cgColor
            layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
            layer.shadowOpacity = shadowOpacity
            layer.shadowPath = shadowPath.cgPath
        }
    }
}
