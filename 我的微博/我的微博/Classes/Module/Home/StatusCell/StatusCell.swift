//
//  StatusCell.swift
//  我的微博
//
//  Created by teacher on 15/8/1.
//  Copyright © 2015年 itheima. All rights reserved.
//
import UIKit

/// 控件间距
let statusCellControlMargin: CGFloat = 8.0

/// 微博 Cell 的标示符枚举
enum StatusCellIdentifier: String {
    case NormalCell = "NormalCell"
    case ForwardCell = "ForwardCell"
    
    /// 静态函数
    /// 根据微博数据，返回对应的标示符
    static func cellId(status: Status) -> String {
        return status.retweeted_status == nil ? StatusCellIdentifier.NormalCell.rawValue : StatusCellIdentifier.ForwardCell.rawValue
    }
}

/// 微博 Cell
class StatusCell: UITableViewCell {
    
    /// 微博数据模型
    var status: Status? {
        didSet {
            topView.status = status
            contentLabel.text = status?.text ?? ""
            
            // 设置配图视图数据
            pictureView.status = status
            
            // 设置配图视图的尺寸
            pictureHeightCons?.constant = pictureView.bounds.size.height
            pictureWidthCons?.constant = pictureView.bounds.size.width
            pictureTopCons?.constant = (pictureView.bounds.size.height == 0) ? 0 : statusCellControlMargin
        }
    }
    /// 图片宽度约束
    var pictureWidthCons: NSLayoutConstraint?
    /// 图片高度约束
    var pictureHeightCons: NSLayoutConstraint?
    /// 图片顶部约束
    var pictureTopCons: NSLayoutConstraint?
    
    /// 计算行高
    func rowHeight(status: Status) -> CGFloat {
        // 设置属性
        self.status = status
        // 强行更新布局 － 所有的控件的frame都会发生变化
        // 使用自动布局，不要直接修改frame，修改的工作交给自动布局系统来完成
        layoutIfNeeded()
        // 返回底部视图的最大高度
        return CGRectGetMaxY(bottomView.frame)
    }
    
    // MARK: - 界面设置
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置界面
    func setupUI() {
        // 1. 添加控件
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(bottomView)
        
        // 2. 设置布局
        // 1> 顶部视图
        topView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: contentView, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 53))
        
        // 2> 内容标签
        contentLabel.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: topView, size: nil, offset: CGPoint(x: statusCellControlMargin, y: statusCellControlMargin))
        // 宽度 - 主要和自动计算行高的属性联动使用，如果自己计算行高，还需要设置一属性
        contentView.addConstraint(NSLayoutConstraint(item: contentLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: -2 * statusCellControlMargin))
        
        // 4> 底部视图
        bottomView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 44), offset: CGPoint(x: -statusCellControlMargin, y: statusCellControlMargin))
        // 底部约束
        //        contentView.addConstraint(NSLayoutConstraint(item: bottomView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
    }
    
    // MARK: - 懒加载控件
    /// 顶部视图
    private lazy var topView: StatusTopView = StatusTopView()
    /// 内容标签
    lazy var contentLabel: UILabel = {
        let label = UILabel(color: UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
        // 设置文本折行的宽度，如果不设置此属性，有的时候，行高不准确！
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 2 * statusCellControlMargin
        
        return label
        }()
    /// 配图视图
    lazy var pictureView: StatusPictureView = StatusPictureView()
    /// 底部视图
    lazy var bottomView: StatusBottomView = StatusBottomView()
}
