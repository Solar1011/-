//
//  ProfileTableViewController.swift
//  我的微博
//
//  Created by teacher on 15/7/27.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

class ProfileTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        visitorView?.setupViewInfo(false, imageName: "visitordiscover_image_profile", message: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
    }
}
