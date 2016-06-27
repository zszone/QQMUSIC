//
//  MusicModel.swift
//  QQMusic
//
//  Created by zs on 16/6/23.
//  Copyright © 2016年 zs. All rights reserved.
//

import UIKit

class MusicModel: NSObject {


    //歌曲名字
    var name : String = ""
    //歌曲对应文件名
    var filename : String = ""
    //歌词名字
    var lrcname : String = ""
    //歌手名字
    var singer : String = ""
    //歌手小图片
    var singerIcon : String = ""
    //歌手大图片
    var icon : String = ""
    
    //构造函数
    init(dict : [String : NSObject]){
      super.init()
        setValuesForKeysWithDictionary(dict)
    
    }
    
}
