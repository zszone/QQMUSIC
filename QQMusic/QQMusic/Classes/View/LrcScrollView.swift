//
//  LrcScrollView.swift
//  QQMusic
//
//  Created by zs on 16/6/25.
//  Copyright © 2016年 zs. All rights reserved.
//

import UIKit

private let LrcTableViewCell = "LrcTableViewCell"
class LrcScrollView: UIScrollView {
    
    
   // MARK:- 懒加载一个tableView
   private lazy var tableView = UITableView()
    
    // MARK:- 定义属性
    var lrclines : [Lrcline]?
    var currentIndex : Int = 0
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
                    
                    //2.4 如果正在显示某一句歌词,就给该句歌词添加颜色的进度
                    if i == currentIndex {
                    
                        //2.4.1 获取当前进度
                        let progress = (currentTime - currentlrcline.lrcTime) / (nextlrcline.lrcTime - currentlrcline.lrcTime)
                        
                        //2.4.2 将进度给lrcLabel,让label根据进度显示颜色
                        let indexPath = NSIndexPath(forRow: i, inSection: 0)
                        guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? LrcViewCell else {
                            continue
                        }
                        
                        cell.lrcLabel.progress = progress
                        
                    }
                    
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
        
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.font = UIFont.systemFontOfSize(15)
        cell.textLabel?.textAlignment = .Center
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.selectionStyle = .None

        if indexPath.row == currentIndex {
             cell.lrcLabel.font = UIFont.systemFontOfSize(16)
        }else {
            cell.lrcLabel.font = UIFont.systemFontOfSize(15)
            cell.lrcLabel.progress = 0
        }
        
        
        cell.textLabel?.text = lrclines![indexPath.row].lrcText
        return cell
    }
    
}
