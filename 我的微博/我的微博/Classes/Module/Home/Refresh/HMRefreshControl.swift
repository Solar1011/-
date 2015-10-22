//
//  HMRefreshControl.swift
//  我的微博
//
//  Created by 刘凡 on 15/8/4.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

/// 下拉偏移量
private let kRefreshPullOffset: CGFloat = -60

class HMRefreshControl: UIRefreshControl {

    // MARK: - KVO
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if frame.origin.y > 0 {
            return
        }
        
        if refreshing {
            refreshView.startLoading()
            return
        }
        
        if frame.origin.y < kRefreshPullOffset && !refreshView.rotateFlag {
            print("翻过来")
            refreshView.rotateFlag = true
        } else if frame.origin.y > kRefreshPullOffset && refreshView.rotateFlag {
            print("转过去")
            refreshView.rotateFlag = false
        }
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        
        refreshView.stopLoading()
    }
    
    // MARK: - 构造函数
    override init() {
        super.init()
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    deinit {
        removeObserver(self, forKeyPath: "frame")
    }
    
    private func setupUI() {
        // KVO
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        
        // 隐藏转轮
        tintColor = UIColor.clearColor()
        // 添加刷新视图
        addSubview(refreshView)
        
        refreshView.ff_AlignInner(type: ff_AlignType.CenterCenter, referView: self, size: refreshView.bounds.size)
    }
    
    // MARK: - 懒加载控件
    private lazy var refreshView = HMRefreshView.refreshView()
}

class HMRefreshView: UIView {
    
    /// 翻转标记
    private var rotateFlag = false {
        didSet {
            rotateAnimation()
        }
    }
    
    /// 加载图标
    @IBOutlet weak var loadIcon: UIImageView!
    /// 提示视图
    @IBOutlet weak var tipView: UIView!
    /// 提示图标
    @IBOutlet weak var tipIcon: UIImageView!
    
    /// 从 xib 加载刷新视图
    class func refreshView() -> HMRefreshView {
        return NSBundle.mainBundle().loadNibNamed("HMRefreshView", owner: nil, options: nil).last as! HMRefreshView
    }
    
    /// 旋转提示图标动画
    private func rotateAnimation() {
        
        let angle = rotateFlag ? CGFloat(M_PI - 0.01) : CGFloat(M_PI + 0.01)
        
        UIView.animateWithDuration(0.3) { () -> Void in
            self.tipIcon.transform = CGAffineTransformRotate(self.tipIcon.transform, angle)
        }
    }
    
    /// 开始加载动画
    private func startLoading() {
        if loadIcon.layer.animationForKey("loadingAnim") != nil {
            print("动画开始了")
            return
        }
        
        tipView.hidden = true
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        anim.toValue = 2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 0.5
        
        loadIcon.layer.addAnimation(anim, forKey: "loadingAnim")
    }

    /// 停止加载动画
    private func stopLoading() {
        tipView.hidden = false
        
        loadIcon.layer.removeAllAnimations()
    }
}
