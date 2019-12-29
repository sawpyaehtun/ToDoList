//
//  UIView + Animation.swift
//  To-Do
//
//  Created by sawpyaehtun on 08/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

extension UIView {
   
    func startAnimationMoveCurve(fromPoint start : CGPoint, toPoint end: CGPoint, delayTime : Double, duration : Double, completionHandler : (()-> ())?)
    {
        // The animation
        let animation = CAKeyframeAnimation(keyPath: "position")

        // Animation's path
        let path = UIBezierPath()

        // Move the "cursor" to the start
        path.move(to: start)

        // Calculate the control points
        let c1 = CGPoint(x: start.x + UIScreen.main.bounds.width / 3, y: start.y - UIScreen.main.bounds.width / 3)
        let c2 = CGPoint(x: end.x, y: end.y - 128)

        // Draw a curve towards the end, using control points
        path.addCurve(to: end, controlPoint1: c1, controlPoint2: c2)

        // Use this path as the animation's path (casted to CGPath)
        animation.path = path.cgPath;

        // The other animations properties
        animation.fillMode              = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.beginTime = CACurrentMediaTime() + delayTime
        animation.duration              = duration
        animation.timingFunction        = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeIn)

        // Apply it
        layer.add(animation, forKey:"trash")
        
        guard let completionHandler = completionHandler else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime + duration) {
            completionHandler()
        }
    }
}
