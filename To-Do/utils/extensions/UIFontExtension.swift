//
//  UIFontExtension.swift
//  PADCHotelBooking
//
//  Created by saw pyaehtun on 06/09/2019.
//  Copyright © 2019 saw pyaehtun. All rights reserved.
//

import Foundation

import UIKit
extension UIFont {
    
    class func fixedAppFont(size: CGFloat, isScaled: Bool = true) -> UIFont {
        return UIFont(name: "MarkPro", size: size)!
    }
    
    class func fixedAppBoldFont(size: CGFloat, isScaled: Bool = true) -> UIFont {
        return UIFont(name: "MarkPro-Bold", size: size)!
    }
    
}
