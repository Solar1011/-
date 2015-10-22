//
//  UserAccount.swift
//  我的微博
//
//  Created by teacher on 15/7/29.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

/// 用户模型
class UserAccount: NSObject,NSCoding {
    
    //用户登录标记
    class var userLogon: Bool {
        return sharedAccount != nil
        
    }
    
    /// 用于调用access_token，接口获取授权后的access token
    var access_token: String?
    /// access_token的生命周期，单位是秒数 - 准确的数据类型是`数值`
    var expires_in: NSTimeInterval = 0 {
        didSet{
            print(__FUNCTION__)
            expiresDate = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    
    
    //过期日期
    var expiresDate:NSDate?
    /// 当前授权用户的UID
    var uid: String?
    
    ///友好显示名称
    var name : String?
    ///用户头像地址,
    var avatar_large: String?
    
    
    
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        //设置全局的用户信息
        UserAccount.userAccount = self
        
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    /// 对象描述信息
    override var description: String {
        let properties = ["access_token", "expires_in", "uid","expiresDate","name","avatar_large"]
        
        return "\(dictionaryWithValuesForKeys(properties))"
    }
    //MARK: - 加载用户信息  职责: 异步获取用户附加信息,保存当前用户信息
    func loadUserInfo(finished: (error:NSError? ) -> ()){
        NetworkTools.sharedTools.loadUserInfo(uid!) {
            (result,error ) -> ()in
            if error != nil {
                //提示:error一定要传递
                finished(error: error)
                return
            }
            self.name = result!["name"] as? String
            self.avatar_large = result!["avatar_large"] as? String
            //保存用户信息
            self.saveAccount()
            //完成回调
            finished(error: nil)
        }
    }
    
    //MARK: - 归档&解档的方法
    //保存归档文件的路径
    static private let accountPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!.stringByAppendingString("account.plist")
    ///保存用户帐号
    func saveAccount(){
        NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.accountPath)
    }
    /*
    如果没有登录,返回空
    如果token过期 返回空
    
    由于所有后续的网路访问,都依赖token,每次都要读取
    如果每次都要"解档",需要从硬盘进行读取(硬盘 I/O),实际开发中,需要注意缓存!
    
    */
    ///静态的用户账户属性
    private static var userAccount: UserAccount?
    
    class var sharedAccount : UserAccount? {
        
        //1,判断账户是否存在
        if userAccount == nil {
            userAccount = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath )as? UserAccount
        }
        //2,判断日期
        if let date = userAccount?.expiresDate where date.compare(NSDate()) == NSComparisonResult.OrderedAscending{
            userAccount = nil
            
        }
        
        return userAccount
    }
    
    //MARK: - NSCoding
    ///归档 -> 保存,将自定义对象转换成二进制数据保存到磁盘
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeDouble(expires_in, forKey: "expires_in")
        aCoder.encodeObject(expiresDate, forKey: "expiresDate")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(name,forKey: "name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    ///解档 -> 恢复,将二进制数据从磁盘恢复成自定义对象
    required init?(coder aDecoder: NSCoder ){
        access_token = aDecoder.decodeObjectForKey("access_token") as?String
        expires_in = aDecoder.decodeDoubleForKey("expires_in")
        expiresDate = aDecoder.decodeObjectForKey("expiresDate") as?NSDate
        uid = aDecoder.decodeObjectForKey("uid") as?String
        name = aDecoder.decodeObjectForKey("name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        
        
    }
    
}
