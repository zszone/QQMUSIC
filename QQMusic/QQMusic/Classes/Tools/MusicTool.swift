//
//  MusicTool.swift
//  QQMusic
//
//  Created by zs on 16/6/23.
//  Copyright © 2016年 zs. All rights reserved.
//

import UIKit

class MusicTool: NSObject {
    static var music : [MusicModel] = {
        
        //获取plist文件
        let filaPath = NSBundle.mainBundle().pathForResource("Musics", ofType: "plist")!
        
        //读取数据
        let array = NSArray(contentsOfFile:filaPath)!
        
        //遍历数组中所有的dict
        var tempArray = [MusicModel]()
        for dict in array as! [[String : NSObject]] {
           tempArray.append(MusicModel(dict: dict))
        
        }
        return tempArray
        
    }()
    
    static var currentMusic : MusicModel? = MusicTool.music[3]
    
}

// MARK:- 获取上一首或者下一首歌曲
extension MusicTool {
 
    class func getPreviousMusic() -> MusicModel? {
       //判断当前歌曲是否有值
        guard  let currentM = currentMusic else {
          return nil
        }
       
        //2.获取当前索引
        let currentIndex = music.indexOf(currentM)!
        
        //3.计算上一首歌的索引
        var previousIndex = currentIndex - 1
        
        if previousIndex < 0 {
            previousIndex = music.count - 1
        }
        //4.返回上一首歌
        return music[previousIndex]
    }
    
    class func getNextMusic() -> MusicModel? {
        //判断当前歌曲是否有值
        guard  let currentM = currentMusic else {
            return nil
        }
        
        //2.获取当前索引
        let currentIndex = music.indexOf(currentM)!
        
        //3.计算上一首歌的索引
        var nestIndex = currentIndex + 1
        
        if nestIndex > music.count - 1 {
            nestIndex = 0
        }
        //4.返回上一首歌
        return music[nestIndex]
    }
    
    
}