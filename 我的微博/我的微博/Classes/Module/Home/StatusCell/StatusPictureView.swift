//
//  StatusPictureView.swift
//  我的微博
//
//  Created by teacher on 15/8/2.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit
import SDWebImage

/// 可重用 cell 标示符
private let statusPictureViewCellID = "statusPictureViewCellID"

/// 配图视图
class StatusPictureView: UICollectionView {

    var status: Status? {
        didSet {
            sizeToFit()
            // 刷新视图
            reloadData()
        }
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        return calcViewSize()
    }
    
    /// 计算视图大小
    private func calcViewSize() -> CGSize {
        // 0. 准备常量
        let itemSize = CGSize(width: 90, height: 90)
        let margin: CGFloat = 10
        // 每一行最多显示的图片数量
        let rowCount = 3
        
        pictureLayout.itemSize = itemSize
        
        // 1. 根据图片数量计算视图大小
        let count = status?.pictureURLs?.count ?? 0
        
        // 1> 没有图片
        if count == 0 {
            return CGSizeZero
        }
        
        // 2> 1张图片
        if count == 1 {
            // 从 SDWebImage 获取图片缓存大小
            // key 就是 URL 的完整字符串
            let key = status!.pictureURLs![0].absoluteString
            // 提示 image 未必一定会被缓存下来
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key)
            
            // 如果图像不存在的默认大小
            var size = CGSize(width: 150, height: 120)
            
            // 判断图像是否存在
            if image != nil {
                size = image.size
            }
            
            // 对图像尺寸做进一步判断，防止出现过宽、过窄的情况
            size.width = size.width < 40 ? 40 : size.width
            size.width = size.width > UIScreen.mainScreen().bounds.width ? 150 : size.width
            
            pictureLayout.itemSize = size
            return size
        }
        
        // 3> 4张图片 2 * 2
        if count == 4 {
            let w = itemSize.width * 2 + margin
            
            return CGSize(width: w, height: w)
        }
        
        // 4> 其他
        /**
            2, 3
            5, 6
            7, 8, 9
        */
        // 计算行数
        let row = (count - 1) / rowCount + 1
        let w = itemSize.width * CGFloat(rowCount) + margin * CGFloat(rowCount - 1)
        let h = itemSize.height * CGFloat(row) + margin * CGFloat(row - 1)
        
        return CGSize(width: w, height: h)
    }
    
    /// 图片布局
    private let pictureLayout = UICollectionViewFlowLayout()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        // 提示：调用父类的构造函数之前，必须给本类的属性初始化
        super.init(frame: frame, collectionViewLayout: pictureLayout)
        
        backgroundColor = UIColor.lightGrayColor()
        
        // 注册可重用 cell
        registerClass(StatusPictureViewCell.self, forCellWithReuseIdentifier: statusPictureViewCellID)

        // 设置代理，让自己当自己的数据源，在开发的时候，如果有局部小视图，可以自己充当自己的数据源或者代理
        self.dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// 在 swift 中，协议同样可以通过 extension 来写，可以将一组协议方法，放置在一起，便于代码维护和阅读！
extension StatusPictureView: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.pictureURLs?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(statusPictureViewCellID, forIndexPath: indexPath) as! StatusPictureViewCell
        
        cell.imageURL = status!.pictureURLs![indexPath.item]
        
        return cell
    }
}

class StatusPictureViewCell: UICollectionViewCell {
    
    var imageURL: NSURL? {
        didSet {
            iconView.sd_setImageWithURL(imageURL!)
        }
    }
    
    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(iconView)
        
        iconView.ff_Fill(contentView)
    }
    
    // MARK: 懒加载控件
    private lazy var iconView: UIImageView = {
        let iv = UIImageView()
        
        iv.contentMode = UIViewContentMode.ScaleAspectFill
        // 超出边界范围直接裁剪掉
        iv.clipsToBounds = true
        
        return iv
    }()
}
