//
//  DiscoverTableViewController.swift
//  我的微博
//
//  Created by teacher on 15/7/27.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

class DiscoverTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        visitorView?.setupViewInfo(false, imageName: "visitordiscover_image_message", message: "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过")
    }
}
