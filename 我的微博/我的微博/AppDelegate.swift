//
//  AppDelegate.swift
//  我的微博
//
//  Created by teacher on 15/7/27.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit
import AFNetworking

/// 在类的外面写的常量或者变量就是全局能够访问的
/// 视图控制器切换通知字符串
let HMRootViewControllerSwitchNotification = "HMRootViewControllerSwitchNotification"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "switchViewController:", name: HMRootViewControllerSwitchNotification, object: nil)
        // 网络指示器
        AFNetworkActivityIndicatorManager.sharedManager().enabled = true
        
        print(UserAccount.sharedAccount)
        
        setupAppearance()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = defaultViewController()
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
    /// 程序被销毁才会执行
    deinit {
        // 注销通知 - 只是一个习惯
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /// 切换控制器，记住：一定在 AppDelegate 中统一修改！
    func switchViewController(n: NSNotification) {
        print("切换控制器 \(n)")
        let mainVC = n.object as! Bool
        
        window?.rootViewController = mainVC ? MainViewController() : WelcomeViewController()
    }
    
    /// 返回启动默认的控制器
    private func defaultViewController() -> UIViewController {
        
        // 1. 判断用户是否登录，如果没有登录返回主控制器
        if !UserAccount.userLogon {
            return MainViewController()
        }
        
        // 2. 判断是否新版本，如果是，返回新特性，否则返回欢迎
        return isNewUpdate() ? NewFeatureViewController() : WelcomeViewController()
    }
    
    /// 检查是否有新版本
    private func isNewUpdate() -> Bool {
        // 1. 获取程序当前的版本
        let currentVersion = Double(NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String)!
        
        // 2. 获取程序`之前`的版本，偏好设置
        let sandboxVersionKey = "sandboxVersionKey"
        let sandboxVersion = NSUserDefaults.standardUserDefaults().doubleForKey(sandboxVersionKey)
        
        // 3. 将当前版本保存到偏好设置
        NSUserDefaults.standardUserDefaults().setDouble(currentVersion, forKey: sandboxVersionKey)
        // iOS 7.0 之后，就不需要同步了，iOS 6.0 之前，如果不同步不会第一时间写入沙盒
        NSUserDefaults.standardUserDefaults().synchronize()
        
        // 4. 返回比较结果
        return currentVersion > sandboxVersion
    }
    
    /// 设置外观
    private func setupAppearance() {
        // 一经设置，全局有效，应该尽早设置
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
    }
}

