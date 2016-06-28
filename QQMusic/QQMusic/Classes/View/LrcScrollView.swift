//
//  LrcScrollView.swift
//  QQMusic
//
//  Created by zs on 16/6/25.
//  Copyright © 2016年 zs. All rights reserved.
//

import UIKit

private let LrcTableViewCell = "LrcTableViewCell"

protocol lrcScrollViewDelegate : class {
    func lrcScrollView(lrcView : LrcScrollView, currentLrcText : String, lrcImage : UIImage?)
    func lrcScrollView(lrcView : LrcScrollView, progress : Double)
}


class LrcScrollView: UIScrollView {
    
    
   // MARK:- 懒加载一个tableView
   private lazy var tableView = UITableView()
    
    // MARK:- 定义属性
    var lrclines : [Lrcline]?
    var currentIndex : Int = 0
    weak var lrcDelegate : lrcScrollViewDelegate?
    var lrcfileName : String = "" {
    
        didSet{
          
            //1.获取歌词
            lrclines = LrcTool.lrcToolWithLrcName(lrcfileName)
            
            //2.刷新表格
            tableView.reloadData()
        
        }
    }
    
    var currentTime : NSTimeInterval = 0 {
      
        didSet {
         
            //1.效验是否有歌词
            guard let lrclines = lrclines else {
              return
            }
            
            //2.将所有的歌词进行遍历
            let count = lrclines.count
            for i in 0..<count {
                //2.1 获取i位置的歌词
                let currentlrcline = lrclines[i]
                
                //2.2获取i+1位置的歌词
                
                let nextIndex = i + 1
                if nextIndex > count - 1 {
                    break
                }
            
                let  nextlrcline = lrclines[nextIndex]
                
                //2.3 判断当前时间是否大于i位置的时间,并且小于i+1位置的时间
                if currentTime > currentlrcline.lrcTime && currentTime < nextlrcline.lrcTime && currentIndex != i {
                
                    //2.3.1 根据i创建对应的indexpath
                    let indexPath = NSIndexPath(forRow: i, inSection: 0)
                    let previousPath = NSIndexPath(forRow: currentIndex, inSection: 0)
                    
                    //2.3.2 计算当前i
                    currentIndex = i
                    
                    //2.3.3 刷新i位置的cell
                    tableView.reloadRowsAtIndexPaths([previousPath,indexPath], withRowAnimation: .None)
                    
                    //滚动到对应的位置
                    tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
                    
                    // 画图有歌词的图片
                    let lrcImage = createLrcImage(i)
                    
                     //通知代理,切换歌词
                    lrcDelegate?.lrcScrollView(self, currentLrcText: currentlrcline.lrcText,lrcImage: lrcImage)
                    
                }
                
                //2.4 如果正在显示某一句歌词,就给该句歌词添加颜色的进度
                if i == currentIndex {
                    
                    //2.4.1 获取当前进度
                    var progress = (currentTime - currentlrcline.lrcTime) / (nextlrcline.lrcTime - currentlrcline.lrcTime)
                    if progress < 0 {
                        progress = 0.001
                    }
                    
                    //2.4.2 将进度给lrcLabel,让label根据进度显示颜色
                    let indexPath = NSIndexPath(forRow: i, inSection: 0)
                    guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? LrcViewCell else {
                        continue
                    }
                   
                    
                    cell.lrcLabel.progress = progress
                
                    //通知代理,当前的进度
//                    lrcDelegate?.lrcScrollView(self, progress: progress)
                    
                    
                }
            }
            
            
        }
    
        
    }
    
   // MARK:- 重写构造函数
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
        tableView.frame.origin.x = bounds.width
        tableView.contentInset = UIEdgeInsets(top: bounds.height * 0.5, left: 0, bottom: bounds.height * 0.5, right: 0)
    }
}

extension LrcScrollView {
 
    func setupTableView() {
        addSubview(tableView)
        tableView.backgroundColor = UIColor.clearColor()
        tableView.registerClass(LrcViewCell.self, forCellReuseIdentifier: LrcTableViewCell)
        tableView.separatorStyle = .None
        tableView.rowHeight = 35
        tableView.dataSource = self
    }
    
}

extension LrcScrollView : UITableViewDataSource {
  
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lrclines?.count ?? 0
        
//        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //创建cell
        let cell = tableView.dequeueReusableCellWithIdentifier(LrcTableViewCell, forIndexPath: indexPath) as! LrcViewCell

        if indexPath.row == currentIndex {
             cell.lrcLabel.font = UIFont.systemFontOfSize(16)
        }else {
            cell.lrcLabel.font = UIFont.systemFontOfSize(15)
            cell.lrcLabel.progress = 0
        }
        
        
        cell.lrcLabel.text = lrclines![indexPath.row].lrcText
        
        return cell
    }
    
}


// MARK:- 画图有歌词的图片
extension LrcScrollView {
    private func createLrcImage(index : Int) -> UIImage? {
        // 1.获取当前显示的图片
        guard let currentMusic = MusicTool.currentMusic else {
            return nil
        }
        let currentImage = UIImage(named: currentMusic.icon)!
        
        // 2.开启图像上下文
        UIGraphicsBeginImageContextWithOptions(currentImage.size, true, 0.0)
        
        // 3.将图片画到上下文中
        currentImage.drawInRect(CGRect(origin: CGPointZero, size: currentImage.size))
        
        // 4.获取歌词
        // 4.1.获取当前句的歌词
        let currentLrc = lrclines![index].lrcText
        
        // 4.2.获取上一句的歌词
        let previousIndex = index - 1
        var previousLrc = ""
        if previousIndex > 0 {
            previousLrc = lrclines![previousIndex].lrcText
        }
        
        // 4.3.获取下一句的歌词
        let nextIndex = index + 1
        var nextLrc = ""
        if nextIndex <= lrclines!.count - 1 {
            nextLrc = lrclines![nextIndex].lrcText
        }
        
        // 5.将歌词画到上下文中
        // 5.0.定义文字的属性
        let style = NSMutableParagraphStyle()
        style.alignment = .Center
        let attributes = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(14.0), NSParagraphStyleAttributeName : style]
        
        // 5.2.定义常量
        let h : CGFloat = 30
        let imageW = currentImage.size.width
        let imageH = currentImage.size.height
        
        // 5.1.将下一句歌词画到上下文中
        let nextRect = CGRect(x: 0, y: imageH - h, width: imageW, height: h)
        (nextLrc as NSString).drawInRect(nextRect, withAttributes: attributes)
        
        // 5.2.将当前句歌词画到上下文中
        let currentRect = CGRect(x: 0, y: imageH - 2 * h, width: imageW, height: h)
        (currentLrc as NSString).drawInRect(currentRect, withAttributes: attributes)
        
        // 5.3.将上一句歌词画到上下文中
        let previousRect = CGRect(x: 0, y: imageH - 3 * h, width: imageW, height: h)
        (previousLrc as NSString).drawInRect(previousRect, withAttributes: attributes)
        
        // 6.从上下文中获取图片
        let lrcImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 7.关闭上下文
        UIGraphicsEndImageContext()
        
        return lrcImage
    }
}

