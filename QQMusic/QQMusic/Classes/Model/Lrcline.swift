//
//  Lrcline.swift
//  QQMusic
//
//  Created by zs on 16/6/25.
//  Copyright © 2016年 zs. All rights reserved.
//

import UIKit

class Lrcline: NSObject {
    var lrcTime : NSTimeInterval = 0
    var lrcText : String = ""
    
    //[00:33.20]只是因为在人群中多看了你一眼
    init(lrclineString : String) {
        super.init()
        
        lrcText = lrclineString.componentsSeparatedByString("]")[1]
        let range = Range(start: lrclineString.startIndex.advancedBy(1), end: lrclineString.startIndex.advancedBy(9))
         lrcTime = timeWithTimeStr(lrclineString.substringWithRange(range))
    }
    
    private func timeWithTimeStr(timeString : String) -> NSTimeInterval {
    // 03:21.82
        let min = Double((timeString as NSString).substringToIndex(2))!
        let second = Double((timeString as NSString).substringWithRange(NSRange(location: 3, length: 2)))!
        let haomiao = Double((timeString as NSString).substringFromIndex(6))!
        
        return (min * 60 + second + haomiao * 0.01)
        
    }
}
