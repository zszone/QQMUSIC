//
//  PlayingViewController.swift
//  QQMusic
//
//  Created by zs on 16/6/23.
//  Copyright © 2016年 zs. All rights reserved.
//

import UIKit

class PlayingViewController: UIViewController {

    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var progressView: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        progressView.setThumbImage(UIImage(named: "player_slider_playback_thumb"), forState: .Normal)
    }
    
    override func viewDidAppear(animated: Bool) {
        setupIconViewCorner()
    }

}

extension PlayingViewController {
  
    private func setupIconViewCorner() {
        iconView.layer.cornerRadius = iconView.bounds.width * 0.5
        iconView.layer.masksToBounds = true
        iconView.layer.borderWidth = 10
        iconView.layer.borderColor = UIColor.darkGrayColor().CGColor
        
        
    
    }

}