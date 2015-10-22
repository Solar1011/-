//
//  NewFeatureViewController.swift
//  我的微博
//
//  Created by teacher on 15/7/30.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class NewFeatureViewController: UICollectionViewController {
    
    /// 图像总数
    private let imageCount = 4
    /// 布局属性
    private let layout = HMFlowLayout()
    
    // 没有 override，因为 collectionView 的指定的构造函数是带 layout 的
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 本类禁止用 sb 开发 - 纯代码开发，考虑因素少，风险小
        // fatalError("init(coder:) has not been implemented")
        // 本类允许用 sb 开发，有些公司是混合开发！需要考虑的因素多，都需要测试才行！
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.registerClass(NewFeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    // MARK: UICollectionViewDataSource
    // 1. 获取数据源，确认有 cell
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCount
    }
    
    // 3. 获取每个索引对应的cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewFeatureCell
        
        // Configure the cell
        cell.imageIndex = indexPath.item
        
        return cell
    }
    
    /// 完成显示 cell - indexPath 是之前消失 cell 的 indexPath
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        // 获取当前显示的 indexPath
        let path = collectionView.indexPathsForVisibleItems().last!
        
        // 判断是否是末尾的 indexPath
        if path.item == imageCount - 1 {
            // 播放动画
            let cell = collectionView.cellForItemAtIndexPath(path) as! NewFeatureCell
            cell.startButtonAnim()
        }
    }
}

/// 新特性的 cell
class NewFeatureCell: UICollectionViewCell {
    
    /// 图像索引 - 私有属性，在同一个文件中，是允许访问的！
    private var imageIndex: Int = 0 {
        didSet {
            iconView.image = UIImage(named: "new_feature_\(imageIndex + 1)")
            startButton.hidden = true
        }
    }
    
    /// 开始体验
    func clickStartButton() {
        NSNotificationCenter.defaultCenter().postNotificationName(HMRootViewControllerSwitchNotification, object: true)
    }
    
    /// 开始按钮动画
    private func startButtonAnim() {
        startButton.hidden = false
        startButton.transform = CGAffineTransformMakeScale(0, 0)
        // 禁用按钮操作
        startButton.userInteractionEnabled = false
        
        UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            
            // 恢复默认形变
            self.startButton.transform = CGAffineTransformIdentity
            
            }) { (_) -> Void in
                // 启用按钮点击
                self.startButton.userInteractionEnabled = true
        }
    }
    
    // MARK: - 设置 UI
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prepareUI()
    }
    
    private func prepareUI() {
        // 添加控件 - 建议都加载 contentView 上
        contentView.addSubview(iconView)
        contentView.addSubview(startButton)
        
        // 自动布局
        iconView.ff_Fill(contentView)
        startButton.ff_AlignInner(type: ff_AlignType.BottomCenter, referView: contentView, size: nil, offset: CGPoint(x: 0, y: -160))
    }
    
    // MARK: - 懒加载控件
    private lazy var iconView = UIImageView()
    private lazy var startButton: UIButton = {
        let button = UIButton()
        
        button.setBackgroundImage(UIImage(named: "new_feature_finish_button"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), forState: UIControlState.Highlighted)
        button.setTitle("开始体验", forState: UIControlState.Normal)
        // 根据背景图片自动调整大小
        button.sizeToFit()
        
        // 提示: 按钮的隐藏属性会因为复用工作不正常
        button.hidden = true
        
        button.addTarget(self, action: "clickStartButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
        }()
}

/// 自定义流水布局
private class HMFlowLayout: UICollectionViewFlowLayout {
    
    // 2. 如果还没有设置 layout，获取数量之后，准备cell之前，会被调用一次
    // 准备布局属性
    private override func prepareLayout() {
        itemSize = collectionView!.bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
    }
}
