//
//  ScrollPositionManager.swift
//  To-Do
//
//  Created by sawpyaehtun on 18/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ScrollPositionManager {
    let scrollContentOffsetX = BehaviorRelay<CGFloat>(value: 0.0)
    static let shared = ScrollPositionManager()
}
