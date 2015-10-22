//
//  MainViewController.swift
//  我的微博
//
//  Created by teacher on 15/7/27.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildViewControllers()
        // 此时 tabBarButton 还没有创建
        print(tabBar.subviews)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 此时 tabBarButton 都已经创建
        setupComposedButton()
    }
    
    /// 运行循环监听到事件后，向 VC 发送消息，动态执行 方法，因此不能设置为 private
    func clickComposedButton() {
        print(__FUNCTION__)
    }
    
    /// 设置撰写按钮位置
    private func setupComposedButton() {
        let w = tabBar.bounds.width / CGFloat(viewControllers!.count)
        
        let rect = CGRect(x: 0, y: 0, width: w, height: tabBar.bounds.height)
        composeButton.frame = CGRectOffset(rect, 2 * w, 0)
    }

    /// 添加所有控制器
    private func addChildViewControllers() {
        // 只是添加控制器，并没有创建 tabBar 的 button
        addChildViewController(HomeTableViewController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(MessageTableViewController(), title: "消息", imageName: "tabbar_message_center")
        addChildViewController(UIViewController())
        addChildViewController(DiscoverTableViewController(), title: "发现", imageName: "tabbar_discover")
        addChildViewController(ProfileTableViewController(), title: "我", imageName: "tabbar_profile")
    }
    
    /// 添加子控制器
    private func addChildViewController(vc: UIViewController, title: String, imageName: String) {
        
        // title 属性会从内向外传递设置
        vc.title = title
        vc.tabBarItem.image = UIImage(named: imageName)
        
        let nav = UINavigationController(rootViewController: vc)
        
        addChildViewController(nav)
    }
    
    // MARK: - 懒加载控件
    lazy private var composeButton: UIButton = {
        // 自定义类型的按钮
        let button = UIButton()
        
        button.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        self.tabBar.addSubview(button)
        button.addTarget(self, action: "clickComposedButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
}
