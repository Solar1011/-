//
//  MessageTableViewController.swift
//  我的微博
//
//  Created by teacher on 15/7/27.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

class MessageTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        visitorView?.setupViewInfo(false, imageName: "visitordiscover_image_message", message: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知")
    }
}
