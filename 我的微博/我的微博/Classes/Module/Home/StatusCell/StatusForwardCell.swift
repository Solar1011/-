//
//  StatusForwardCell.swift
//  我的微博
//
//  Created by teacher on 15/8/2.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

class StatusForwardCell: StatusCell {
    
    /// `重写`属性 didSet 不会覆盖父类的方法！子类只需要继续设置自己的相关内容即可！
    /// 需要和父类保持同样的行为
    override var status: Status? {
        didSet {
            let name = status?.retweeted_status?.user?.name ?? ""
            let text = status?.retweeted_status?.text ?? ""
            
            forwardLabel.text = "@" + name + ":" + text
        }
    }
    
    /// 设置界面
    override func setupUI() {
        super.setupUI()
        
        // 1. 添加控件
        contentView.insertSubview(backButton, belowSubview: pictureView)
        contentView.insertSubview(forwardLabel, aboveSubview: backButton)
        
        // 排版时测试
        // forwardLabel.text = "哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈"
        
        // 2. 设置布局
        // 1> 背景按钮
        backButton.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: nil, offset: CGPoint(x: -statusCellControlMargin, y: statusCellControlMargin))
        backButton.ff_AlignVertical(type: ff_AlignType.TopRight, referView: bottomView, size: nil)
        
        // 2> 转发文本
        forwardLabel.ff_AlignInner(type: ff_AlignType.TopLeft, referView: backButton, size: nil, offset: CGPoint(x: statusCellControlMargin, y: statusCellControlMargin))
        
        // 3> 配图视图
        let cons = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: forwardLabel, size: CGSize(width: 290, height: 290), offset: CGPoint(x: 0, y: statusCellControlMargin))
        pictureWidthCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        pictureTopCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Top)
    }
    
    // MARK: - 懒加载控件
    /// 转发文字
    private lazy var forwardLabel: UILabel = {
        let label = UILabel(color: UIColor.darkGrayColor(), fontSize: 14)
        
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 2 * statusCellControlMargin
        
        return label
    }()
    private lazy var backButton: UIButton = {
        let btn = UIButton()

        btn.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        return btn
    }()
}
