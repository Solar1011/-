//
//  WelcomeViewController.swift
//  我的微博
//
//  Created by teacher on 15/7/30.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {
    
    /// 图像底部约束
    private var iconBottomCons: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        
        // 加载用户头像
        if let urlString = UserAccount.sharedAccount?.avatar_large {
            // 更新图像，会自动更新imageView的大小
            iconView.sd_setImageWithURL(NSURL(string: urlString)!)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 提示：修改约束不会立即生效，添加了一个标记，统一由自动布局系统更新约束
        iconBottomCons?.constant = -UIScreen.mainScreen().bounds.height - iconBottomCons!.constant
        
        // 动画
        UIView.animateWithDuration(1.2, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5.0, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            
            // 强制更新约束
            self.view.layoutIfNeeded()
            
            }) { (_) -> Void in
                
                // 发送通知，切换控制器
                NSNotificationCenter.defaultCenter().postNotificationName(HMRootViewControllerSwitchNotification, object: true)
        }
    }
    
    /// 准备界面
    private func prepareUI() {
        view.addSubview(backImageView)
        view.addSubview(iconView)
        view.addSubview(label)
        
        // 自动布局
        // 1> 背景图片
        backImageView.ff_Fill(view)
        
        // 2> 头像
        let cons = iconView.ff_AlignInner(type: ff_AlignType.BottomCenter, referView: view, size: CGSize(width: 90, height: 90), offset: CGPoint(x: 0, y: -160))
        // 记录底边约束
        iconBottomCons = iconView.ff_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
        
        // 3> 标签
        label.ff_AlignVertical(type: ff_AlignType.BottomCenter, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 16))
    }
    
    // MARK: - 懒加载控件
    // 背景图片
    private lazy var backImageView: UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    /// 用户头像
    private lazy var iconView: UIImageView = {
        
        let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 45
        
        return iv
        }()
    /// 消息文字
    private lazy var label: UILabel = {
        let label = UILabel()
        
        label.text = "欢迎归来"
        label.sizeToFit()
        
        return label
        }()
}
