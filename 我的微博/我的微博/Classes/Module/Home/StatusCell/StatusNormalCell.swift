//
//  StatusNormalCell.swift
//  我的微博
//
//  Created by teacher on 15/8/2.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

/// 原创微博
class StatusNormalCell: StatusCell {

    override func setupUI() {
        super.setupUI()
        
        // 3> 配图视图
        let cons = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: CGSize(width: 290, height: 290), offset: CGPoint(x: 0, y: statusCellControlMargin))
        pictureWidthCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        pictureTopCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Top)
    }
}
