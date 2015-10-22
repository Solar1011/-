//
//  UILabel+Extension.swift
//  我的微博
//
//  Created by teacher on 15/8/1.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

// 扩展中，只能提供便利的构造函数
extension UILabel {
    
    convenience init(color: UIColor, fontSize: CGFloat) {
        self.init()
        
        textColor = color
        font = UIFont.systemFontOfSize(fontSize)
    }
}
