//
//  Status.swift
//  我的微博
//
//  Created by teacher on 15/8/1.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit
import SDWebImage

/// 微博模型
class Status: NSObject {
    /// 微博创建时间
    var created_at: String?
    /// 微博ID
    var id: Int = 0
    /// 微博信息内容
    var text: String?
    /// 微博来源
    var source: String?
    /// 配图数组
    var pic_urls: [[String: AnyObject]]? {
        didSet {
            // 判断数组中是否有数据 nil
            if pic_urls!.count == 0 {
                return
            }
            
            // 实例化数组
            storedPictureURLs = [NSURL]()
            
            // 遍历字典生成 url 的数组
            for dict in pic_urls! {
                if let urlString = dict["thumbnail_pic"] as? String {
                    storedPictureURLs?.append(NSURL(string: urlString)!)
                }
            }
        }
    }
    /// `保存`配图的 URL 的数组
    private var storedPictureURLs: [NSURL]?
    
    /// 配图的URL的`计算型`数组
    /// 如果是原创微博，返回 storedPictureURLs
    /// 如果是转发微博，返回 retweeted_status.storedPictureURLs
    var pictureURLs: [NSURL]? {
        return retweeted_status == nil ? storedPictureURLs : retweeted_status?.storedPictureURLs
    }
    
    /// 用户
    var user: User?
    /// 转发微博
    var retweeted_status: Status?
    /// 显示微博所需的行高
    var rowHeight: CGFloat?
    
    /// 加载微博数据 - 返回`微博`数据的数组
    class func loadStatus(since_id: Int, max_id: Int, finished: (dataList: [Status]?, error: NSError?) -> ()) {
        
        NetworkTools.sharedTools.loadStatus(since_id, max_id: max_id) { (result, error) -> () in
            
            if error != nil {
                finished(dataList: nil, error: error)
                return
            }
            
            /// 判断能否获得字典数组
            if let array = result?["statuses"] as? [[String: AnyObject]] {
                // 遍历数组，字典转模型
                var list = [Status]()
                
                for dict in array {
                    list.append(Status(dict: dict))
                }
                
                // 缓存图片 self. 是本类只有一个
                // 图片缓存结束之后，再进行回调
                self.cacheWebImage(list, finished: finished)
            } else {
                finished(dataList: nil, error: nil)
            }
        }
    }
    
    /// 缓存微博的网络图片，缓存结束之后，才刷新数据
    private class func cacheWebImage(list: [Status], finished: (dataList: [Status]?, error: NSError?) -> ()) {
        
        // 创建调度组
        let group = dispatch_group_create()
        // 缓存图片的大小
        var dataLength = 0
        
        // 循环遍历数组
        for status in list {
            
            // 判断是否有图片
            guard let urls = status.pictureURLs else {
                // urls 为空
                continue
            }
            
            // 遍历 urls 的数组，SDWebImage 缓存图片
            for imageUrl in urls {
                // 入组
                dispatch_group_enter(group)
                SDWebImageManager.sharedManager().downloadImageWithURL(imageUrl, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (image, _, _, _, _) in
                    
                    // 将图像转换成二进制数据
                    let data = UIImagePNGRepresentation(image)!
                    dataLength += data.length
                    
                    dispatch_group_leave(group)
                })
            }
        }
        
        // 监听所有缓存操作的通知
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            // 因为新浪微博的服务器返回的图片都是缩略图，很小，不会占用用户太多时间，对用户体验影响不大！
            print("缓存图片大小 \(dataLength / 1024) K")
            
            // 获得完整的微博数组，可以回调
            finished(dataList: list, error: nil)
        }
    }
    
    // MARK: - 构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        
        // 会调用 setValue forKey 给每一个属性赋值
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        // 判断 key 是否是 user，如果是 user 单独处理
        if key == "user" {
            // 判断 value 是否是一个有效的字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                user = User(dict: dict)
            }
            return
        }
        
        // 判断 key 是否是 retweeted_status 是否为空
        // 转发微博最多只会执行一次
        if key == "retweeted_status" {
            if let dict = value as? [String: AnyObject] {
                retweeted_status = Status(dict: dict)
            }
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    override var description: String {
        let keys = ["created_at", "id", "text", "source", "pic_urls"]
        
        return "\(dictionaryWithValuesForKeys(keys))"
    }
    
}
