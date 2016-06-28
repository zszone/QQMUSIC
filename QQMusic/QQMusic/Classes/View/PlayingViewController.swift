//
//  PlayingViewController.swift
//  QQMusic
//
//  Created by zs on 16/6/23.
//  Copyright © 2016年 zs. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

private let IconViewAnim = "IconViewAnim"
class PlayingViewController: UIViewController {
// MARK:- 定义属性
    weak var player : AVAudioPlayer?
    var progressTimer : NSTimer?
    var lrcTimer : CADisplayLink?
    
    
    @IBOutlet weak var playOrPauseBtn: UIButton!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var progressView: UISlider!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var lrcScrollView: LrcScrollView!
    
    @IBOutlet weak var lrcLabel: LrcLabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startPlayingMusic()
        //1.设置滑块的图片
        progressView.setThumbImage(UIImage(named: "player_slider_playback_thumb"), forState: .Normal)
        
        //2.设置歌词的lrcScrollView的滚动区域
        lrcScrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width * 2, 0)
        lrcScrollView.lrcDelegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //给中间图片添加动画
        addIconViewAnimation()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        setupIconViewCorner()
    }

}

// MARK:- 设置中间小图
extension PlayingViewController {
  
    private func setupIconViewCorner() {
        iconView.layer.cornerRadius = iconView.bounds.width * 0.5
        iconView.layer.masksToBounds = true
        iconView.layer.borderWidth = 10
        iconView.layer.borderColor = UIColor.darkGrayColor().CGColor
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
 
    private func addIconViewAnimation() {
    
       //1.创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        
        //2.给动画设置属性
        rotationAnim.fromValue = 0
        rotationAnim.toValue = M_PI * 2
        rotationAnim.repeatCount = HUGE
        rotationAnim.duration = 30
        
        //3.将动画添加到layer中
        
        iconView.layer.addAnimation(rotationAnim, forKey: nil)
        
    }
    
}

// MARK:- 开始播放歌曲,并设置展示数据
extension PlayingViewController {
  
     private func startPlayingMusic() {
       //1.获取当前正在播放的歌曲
        guard let currentMusic = MusicTool.currentMusic else{
          return
        }
        //2.给界面中控件赋值
        iconView.image = UIImage(named: currentMusic.icon)
        bgImageView.image = UIImage(named: currentMusic.icon)
        songLabel.text = currentMusic.name
        singerLabel.text = currentMusic.singer
        
        //3.播放当前歌曲
        guard let player = MusicPlayerTool.playMusicWithName(currentMusic.filename) else {
          return
        }
        
        self.player = player
        self.player?.delegate = self
        
        //4.讲歌词文件的名字传递给lrcScrollView
        lrcScrollView.lrcfileName = currentMusic.lrcname
        
        // 5.添加动画
        if  iconView.layer.animationForKey(IconViewAnim) != nil {
            iconView.layer.removeAnimationForKey(IconViewAnim)
        }
        addIconViewAnimation()
        
        //4.显示总时长
        totalTimeLabel.text = timeStringWithTime(player.duration)
        
        // 5.添加进度条定时器
        removeProgressTime()
        addProgressTimer()
        
        //6.添加定时器
        removeLrcTimer()
        addLrcTimer()
        
        //7.设置该歌曲的锁屏界面信息
        setupLockScreenInfo(UIImage(named: currentMusic.icon)!)
  
        
    }
    private func timeStringWithTime(time : NSTimeInterval) -> String {
       
        let min = Int(time + 0.5) / 60
        let second = Int(time + 0.5) % 60
        return String(format: "%02d:%02d", arguments: [min, second])
        
        
    }
   
}
// MARK:- 监听prgressView的点击事件
extension PlayingViewController {
 
    @IBAction func sliderTouchDown(sender: UISlider) {
        removeProgressTime()
    }
    
    @IBAction func sliderValueChange(sender: UISlider) {
        let value = Double(sender.value)
        let showTime = value  * Double(player?.duration ?? 0)
        
        //显示进度条
        currentTimeLabel.text = timeStringWithTime(showTime)
    }
    
    @IBAction func sliderTouchupInside(sender: UISlider) {
        
        let showTime = Double(sender.value) * Double(player?.duration ?? 0)
        player?.currentTime = showTime
//        removeProgressTime()
        addProgressTimer()
    }
    
    @IBAction func sliderClick(sender: UITapGestureRecognizer) {
        //记录点击点在progressView上的位置
        let x = Double(sender.locationInView(progressView).x)
        //计算当前点击点占歌曲总长的比例
        let ratio = x / Double(progressView.bounds.width)
        
        //设置当前播放事件
        player?.currentTime = ratio * (player?.duration ?? 0)
        
        //更新进度
        updateProgressInfo()
        
        
        //添加定时器
        if progressTimer == nil {
           
            addProgressTimer()
            
        }
    }

}

// MARK:- 监听播放控制按钮的点击事件
extension PlayingViewController {
 
    @IBAction func playOrPauseBtnClick(sender: UIButton) {
        //1.改变按钮的状态
        sender.selected = !sender.selected
        
        //2.根据状态播放或者暂停音乐
        if sender.selected {
            player?.pause()
            removeProgressTime()
            iconView.layer.pauseAnim()
        }else {
            player?.play()
           addProgressTimer()
           iconView.layer.resumeAnim()
        }
    }
    
    @IBAction func previousMusic() {
        let previousMusic = MusicTool.getPreviousMusic()
        MusicTool.currentMusic = previousMusic
        startPlayingMusic()
    }
    
    @IBAction func nextMusic() {
        let nextMusic = MusicTool.getNextMusic()
        MusicTool.currentMusic = nextMusic
        startPlayingMusic()
        
    }
    
}

// MARK:- 添加定时器
extension PlayingViewController {
  
    private func addProgressTimer() {
     
        progressTimer = NSTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgressInfo), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(progressTimer!, forMode: NSRunLoopCommonModes)
    }
    
    private func removeProgressTime() {
        progressTimer?.invalidate()
        progressTimer = nil
    }
    
   @objc private func updateProgressInfo(){
    
    //获取当前播放的时间
    guard let player = player else {
      return
    }
    
      currentTimeLabel.text = timeStringWithTime(player.currentTime)
    
    //设置进度条
    progressView.value = Float(player.currentTime / player.duration)
    
    }
    
    private func addLrcTimer() {
    
        lrcTimer = CADisplayLink(target: self, selector: #selector(updateLrc))
        lrcTimer?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    private func removeLrcTimer() {
    
        lrcTimer?.invalidate()
        lrcTimer = nil
    }
    
    @objc private func updateLrc() {
    
        lrcScrollView.currentTime = player?.currentTime ?? 0
    }
}

// MARK:- 实现中间歌词view的滚动代理方法
extension PlayingViewController : UIScrollViewDelegate, lrcScrollViewDelegate{
  
    func scrollViewDidScroll(scrollView : UIScrollView) {
        //获取偏移量
        let offsetx = scrollView.contentOffset.x
        
        //计算比例
        let ratio = offsetx / scrollView.bounds.width
        
        //设置iconView的透明度
        iconView.alpha = 1 - ratio
        
        lrcLabel.alpha = 1 - ratio
        
    }
    
    func lrcScrollView(lrcView : LrcScrollView, currentLrcText : String ,lrcImage: UIImage?){
       lrcLabel.text = currentLrcText
        
        if let lrcImage = lrcImage {
            setupLockScreenInfo(lrcImage)
        }
    }

    
    
    
    func lrcScrollView(lrcView : LrcScrollView, progress : Double){
       lrcLabel.progress = progress
    }
    
}

extension PlayingViewController : AVAudioPlayerDelegate {
  
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        nextMusic()
    }

    
}


// MARK:- 设置锁屏界面
extension PlayingViewController {
  
    private func setupLockScreenInfo(lrcImage : UIImage) {
    
        //获取当前歌词
        guard let currentMusic = MusicTool.currentMusic else {
          return
        }
        
       //2.获取播放信息中心
        let center = MPNowPlayingInfoCenter.defaultCenter()
        
        //3.设置中心的内容
        var infoDict = [String : AnyObject]()
        infoDict[MPMediaItemPropertyTitle] = currentMusic.name
        infoDict[MPMediaItemPropertyArtist] = currentMusic.singer
        infoDict[MPMediaItemPropertyPlaybackDuration] = player?.duration ?? 0
        infoDict[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image : lrcImage)
        center.nowPlayingInfo = infoDict
        // 3.让应用程序可以接受远程事件
        UIApplication.sharedApplication().canBecomeFirstResponder()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        guard let event = event else {
            return
        }
        
        switch event.subtype {
        case .RemoteControlNextTrack:
            nextMusic()
        case .RemoteControlPreviousTrack:
            previousMusic()
        case .RemoteControlPlay, .RemoteControlPause:
            playOrPauseBtnClick(playOrPauseBtn)
        default:
            print("其它事件")
        }
    }

}





