//
//  LrcTool.swift
//  QQMusic
//
//  Created by zs on 16/6/25.
//  Copyright © 2016年 zs. All rights reserved.
//

import UIKit

class LrcTool: NSObject {

    class func lrcToolWithLrcName(lrcName : String) -> [Lrcline]? {
       //1读取歌词文件的路径
        guard let filePath = NSBundle.mainBundle().pathForResource(lrcName, ofType: nil) else {
        
         return nil
            
        }
    
        //2读取歌词文件
        guard let lrcString = try? String(contentsOfFile: filePath) else {
           return nil
        }
        
        //3.获取歌词的数组
        let lrcArray = lrcString.componentsSeparatedByString("\n")
        
        //4.遍历数组
        var tempArray = [Lrcline]()
        
        for lrclineString in lrcArray {
         
            if lrclineString.containsString("[ti:") || lrclineString.containsString("[ar:") || lrclineString.containsString("[al:") || !lrclineString.containsString("[") {
              
                continue
            }
            
            //4.2 将字符串转成模型对象
            tempArray.append(Lrcline(lrclineString: lrclineString))
        }
        return tempArray
    }
    
}
