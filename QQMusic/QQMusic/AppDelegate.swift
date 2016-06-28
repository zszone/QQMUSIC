//
//  AppDelegate.swift
//  QQMusic
//
//  Created by zs on 16/6/23.
//  Copyright © 2016年 zs. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        actionForBackgroudMode()
        
        return true
    }
   
    private func actionForBackgroudMode() {
      //获取音频会话
    let session = AVAudioSession.sharedInstance()
        
      //设置会话的类型(后台模式)
    do {
    try session.setCategory(AVAudioSessionCategoryPlayback)
    try session.setActive(true)
    } catch {
         print(error)
    }
    
    }
    
    /*
     private func actionForBackgroudMode() {
     // 1.获取音频会话
     let session = AVAudioSession.sharedInstance()
     
     // 2.设置会话的类别(后台模式)
     do {
     try session.setCategory(AVAudioSessionCategoryPlayback)
     try session.setActive(true)
     } catch {
     print(error)
     }
     }
     */

}

