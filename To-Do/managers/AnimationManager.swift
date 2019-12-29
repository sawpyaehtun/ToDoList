//
//  AnimationManager.swift
//  To-Do
//
//  Created by sawpyaehtun on 09/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation
import UIKit

class AnimationManager {
    static let shared = AnimationManager()
}

extension AnimationManager {
    
    func rotateAnimation(angle : CGFloat, duration : Double) -> CABasicAnimation {
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fillMode = .forwards
        rotate.isRemovedOnCompletion = false
        rotate.fromValue = 0
        rotate.toValue = (CGFloat(.pi * 2.0) * angle) / 360
//        rotate.beginTime = CACurrentMediaTime() + delay
        rotate.duration = duration
        rotate.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        return rotate
    }
    
    func scaleAnimation(fromValue : Double, toValue : Double, duration : Double) ->  CABasicAnimation {
        let scaleUp = CABasicAnimation(keyPath: "transform.scale")
        scaleUp.fillMode = .forwards
        scaleUp.isRemovedOnCompletion = false
        scaleUp.fromValue = fromValue
        scaleUp.toValue = toValue
//        scaleUp.beginTime = CACurrentMediaTime() + delay
        scaleUp.duration = duration
        scaleUp.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        return scaleUp
    }
    
    func moveAlongXAnimation(fromValueX : CGFloat, toValueX : CGFloat, yValue : CGFloat, duration : Double) -> CABasicAnimation {
        
        let fromPoint = CGPoint(x: fromValueX, y: yValue)
        let toPoint = CGPoint(x: toValueX, y: yValue)
        
        let moveAlongx = CABasicAnimation(keyPath: "movement")
        moveAlongx.fillMode = .forwards
        moveAlongx.isRemovedOnCompletion = false
        moveAlongx.fromValue = fromPoint
        moveAlongx.toValue = toPoint
        moveAlongx.duration = duration
        return moveAlongx
    }
    
    
    func groupAnimation(animations : [CABasicAnimation],delay : Double, duration : Double) -> CAAnimationGroup {
        let animationGroup = CAAnimationGroup()
        animationGroup.fillMode = .forwards
        animationGroup.isRemovedOnCompletion = false
        animationGroup.animations = animations
        animationGroup.beginTime = CACurrentMediaTime() + delay
        animationGroup.duration = duration
        return animationGroup
    }
    
}
