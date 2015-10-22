//
//  BaseTableViewController.swift
//  我的微博
//
//  Created by teacher on 15/7/27.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController, VisitorLoginViewDelegate {

    /// 用户登录标记
    var userLogon = UserAccount.userLogon
    //var userLogon = false
    /// 访客视图
    var visitorView: VisitorLoginView?
    
    override func loadView() {
        // 根据用户是否登录判断是否替换根视图
        userLogon ? super.loadView() : setupVisitorView()
    }
    
    /// 设置访客视图
    private func setupVisitorView() {
        visitorView = VisitorLoginView()
        visitorView?.delegate = self
        view = visitorView
        
        // 设置状态栏
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorLoginViewWillRegister")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorLoginViewWillLogin")
    }
    
    // MARK: - VisitorLoginViewDelegate
    func visitorLoginViewWillLogin() {
        let nav = UINavigationController(rootViewController: OAuthViewController())
        
        presentViewController(nav, animated: true, completion: nil)
    }
    
    func visitorLoginViewWillRegister() {
        print("注册")
    }
}
