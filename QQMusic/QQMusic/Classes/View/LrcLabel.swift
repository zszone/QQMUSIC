//
//  LrcLabel.swift
//  QQMusic
//
//  Created by zs on 16/6/26.
//  Copyright © 2016年 zs. All rights reserved.
//

import UIKit

class LrcLabel: UILabel {

    var progress : Double = 0 {
        didSet {
        
              setNeedsDisplay()
            
        }
    }

    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let drawRect = CGRect(x: 0, y: 0, width: rect.width * CGFloat(progress), height: rect.height)
        UIColor.greenColor().set()
        
        UIRectFillUsingBlendMode(drawRect, .SourceIn)
    }
}
