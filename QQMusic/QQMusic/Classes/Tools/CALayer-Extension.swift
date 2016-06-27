//
//  CALayer-Extension.swift
//  QQMusic
//
//  Created by zs on 16/6/25.
//  Copyright © 2016年 zs. All rights reserved.
//

import UIKit

extension CALayer {
 
    func pauseAnim() {
        let pauseTime = convertTime(CACurrentMediaTime(), fromLayer: nil)
        speed = 0
        timeOffset = pauseTime
    }
    
    func resumeAnim() {
        let pauseTime = timeOffset
        speed = 1.0
        timeOffset = 0
        beginTime = 0
        let timeInteval = convertTime(CACurrentMediaTime(), fromLayer: nil) - pauseTime
        
        beginTime = timeInteval
    }
}

