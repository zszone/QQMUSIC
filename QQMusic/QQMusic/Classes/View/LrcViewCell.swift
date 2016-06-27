//
//  LrcViewCell.swift
//  QQMusic
//
//  Created by zs on 16/6/26.
//  Copyright © 2016年 zs. All rights reserved.
//

import UIKit

class LrcViewCell: UITableViewCell {

    lazy var lrcLabel : LrcLabel  = LrcLabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LrcViewCell {
 
    private func setUpUI() {
       
        //1.将label添加到cell中
        contentView.addSubview(lrcLabel)
        
        //2.设置属性
        backgroundColor = UIColor.clearColor()
        lrcLabel.font = UIFont.systemFontOfSize(15)
        lrcLabel.textAlignment = .Center
        lrcLabel.textColor = UIColor.whiteColor()
        selectionStyle = .None
        
        
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        lrcLabel.sizeToFit()
        lrcLabel.center = contentView.center
    }
    
}
