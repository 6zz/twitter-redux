//
//  User.swift
//  twitter
//
//  Created by Shawn Zhu on 9/12/15.
//  Copyright (c) 2015 Shawn Zhu. All rights reserved.
//

import Foundation

var _currentUser: User?
let currentUserKey = "kCurrentUser"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagline: String?
    var favoritedCount: Int
    var followersCount: Int
    var followingsCount: Int
    var tweetsCount: Int
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        let key = "screen_name"
        screenName = "@\(dictionary[key] as! String)"
        profileImageUrl = dictionary["profile_image_url_https"] as? String
        tagline = dictionary["description"] as? String
        favoritedCount = dictionary["favourites_count"] as? Int ?? 0
        followersCount = dictionary["followers_count"] as? Int ?? 0
        followingsCount = dictionary[""] as? Int ?? 0
        tweetsCount = dictionary["statuses_count"] as? Int ?? 0
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
        
                if let data = data {
                    let dictionary = (try! NSJSONSerialization.JSONObjectWithData(data, options: [])) as! NSDictionary
        
                    _currentUser = User(dictionary: dictionary)
                }
            }
        
            return _currentUser
        }
        
        set (user) {
            if let _currentUser = user {
                let data = try? NSJSONSerialization.dataWithJSONObject(_currentUser.dictionary!, options: [])
                
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}