//
//  HomeTableViewController.swift
//  我的微博
//
//  Created by teacher on 15/7/27.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeTableViewController: BaseTableViewController {
    
    /// 微博数据数组
    var statuses: [Status]? {
        didSet {
            // 刷新数据
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 如果用户没有登录，设置访客视图，返回
        if !UserAccount.userLogon {
            visitorView?.setupViewInfo(true, imageName: "visitordiscover_feed_image_smallicon", message: "关注一些人，回这里看看有什么惊喜")
            
            return
        }
        
        prepareTableView()
        loadData()
    }
    
    /// 准备表格视图
    private func prepareTableView() {
        // 注册原型 cell
        tableView.registerClass(StatusNormalCell.self, forCellReuseIdentifier: StatusCellIdentifier.NormalCell.rawValue)
        tableView.registerClass(StatusForwardCell.self, forCellReuseIdentifier: StatusCellIdentifier.ForwardCell.rawValue)
        
        // 设置表格的预估行高 - 尽量准确，能够减少调用行高的次数，能够提高性能
        tableView.estimatedRowHeight = 300
        // 取消分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // 准备刷新控件
        refreshControl = HMRefreshControl()
        refreshControl?.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    /// 上拉刷新标记
    private var pullupLoading = false
    
    /// 加载数据
    func loadData() {
        // 显示刷新控件，注意不会调用监听方法
        refreshControl?.beginRefreshing()
        
        var since_id = self.statuses?.first?.id ?? 0
        var max_id = 0
        if pullupLoading {
            since_id = 0
            max_id = self.statuses?.last?.id ?? 0
        }
        
        Status.loadStatus(since_id, max_id: max_id) { (dataList, error) -> () in
            self.refreshControl?.endRefreshing()
            
            if error != nil {
                SVProgressHUD.showInfoWithStatus("您的网络不给力")
                print(error)
                return
            }
            
            let count = dataList?.count ?? 0
            if since_id > 0 {
                self.showPulldownTips(count)
            }
            if count == 0 {
                return
            }
            
            if since_id > 0 {       // 下拉刷新，将结果拼接到当前数组前面
                self.statuses = dataList! + self.statuses!
            } else if max_id > 0 {  // 上拉刷新，将结果拼接到当前数组后面
                self.statuses! += dataList!
                self.pullupLoading = false
            } else {
                self.statuses = dataList
            }
        }
    }
    
    /// 显示下拉刷新提示
    private func showPulldownTips(count: Int) {
        pulldownTipLabel.text = (count == 0) ? "没有最新的微博" : "刷新到 \(count) 条微博"
        
        let rect = pulldownTipLabel.frame
        UIView.animateWithDuration(1.0, animations: {
            UIView.setAnimationRepeatAutoreverses(true)
            self.pulldownTipLabel.frame = CGRectOffset(rect, 0, rect.height * 3)
            }) { _ in
                self.pulldownTipLabel.frame = rect
        }
    }
    
    // MARK: - 数据源方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 根据微博类型，选取不同的 ID
        let status = statuses![indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusCellIdentifier.cellId(status), forIndexPath: indexPath) as! StatusCell
        
        cell.status = statuses![indexPath.row]
        
        if indexPath.row == (statuses!.count - 1) && !pullupLoading {
            pullupLoading = true
            loadData()
        }
        
        return cell
    }
    
    /// 返回行高 － 如果是固定值，可以直接通过属性设置，效率更高
    /**
    行高缓存
    1. NSCache
    SDWebImage 存在什么问题
    1> 加载 GIF 的时候，内存会狂飙！
    2. 自定义行高`缓存字典`
    3. 直接利用微博的`模型` - 行高数据只是一个小数，并不会有太大的内存消耗！
    不需要在控制器中，额外定义属性！
    
    提示：如果表格高度是固定的，一定不要通过代理返回行高！可以直接设置属性！
    */
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // 判断模型中，是否已经缓存了行高
        // 1. 获取模型
        let status = statuses![indexPath.row]
        
        if let h = status.rowHeight {
            return h
        }
        
        // 2. 获取 cell - dequeueReusableCellWithIdentifier 带 indexPath 的函数会调用计算行高的方法
        // 会造成死循环，在不同版本的 Xcode 中 行高的计算次数不一样！尽量要优化！
        // 如果不做处理，会非常消耗性能！
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusCellIdentifier.cellId(status)) as? StatusCell
        
        // 3. 记录并返回计算的行高
        status.rowHeight = cell!.rowHeight(status)
        
        return status.rowHeight!
    }
    
    // MARK: - 懒加载控件
    /// 下拉提示标签
    private lazy var pulldownTipLabel: UILabel = {
        
        let h: CGFloat = 44
        let rect = CGRect(x: 0, y: -2 * h, width: self.view.bounds.width, height: h)
        let label = UILabel(frame: rect)
        label.backgroundColor = UIColor.orangeColor()
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        
        self.navigationController?.navigationBar.insertSubview(label, atIndex: 0)
        
        return label
        }()
}
