//
//  MusicPlayerTool.swift
//  QQMusic
//
//  Created by zs on 16/6/24.
//  Copyright © 2016年 zs. All rights reserved.
//

import UIKit
import AVFoundation

class MusicPlayerTool: NSObject {

    static var player : AVAudioPlayer?
    
}

extension MusicPlayerTool {
 
    class func playMusicWithName(musicName : String) -> AVAudioPlayer? {
     
        //获取url
        guard let url = NSBundle.mainBundle().URLForResource(musicName, withExtension: nil) else {
          return nil
        }
       
        if player?.url != nil{
//            if ((player?.url?.isEqual(url)) != nil){
//                player?.play()
//                return player
            
            if player!.url!.isEqual(url) {
                player?.play()
                return player
            }
        }
        
        //创建player对象
        guard let tempPlayer = try?AVAudioPlayer(contentsOfURL: url) else {
           return nil
        }
        
        self.player = tempPlayer
        tempPlayer.play()
        
        return tempPlayer
    }
    
    class func pauseMusic() {
      //暂停音乐
        player?.pause()
    }
    
    class func stopMusic() {
        player?.stop()
        player?.currentTime = 0
    }
}

