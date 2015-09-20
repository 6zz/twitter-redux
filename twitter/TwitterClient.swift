//
//  TwitterClient.swift
//  twitter
//
//  Created by Shawn Zhu on 9/12/15.
//  Copyright (c) 2015 Shawn Zhu. All rights reserved.
//

import UIKit

let twitterBaseURL = NSURL(string: "https://api.twitter.com")
let consumerKey = "4FS7BnXsbTcJKxFQv5X5bVQh2"
let consumerSecret = "fFvRjX52Cjd9Hh53wJ6isoct05dgZMMkobDyDERShSBJIYzyxh"

class TwitterClient: BDBOAuth1RequestOperationManager {
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
   
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(
                baseURL: twitterBaseURL,
                consumerKey: consumerKey,
                consumerSecret: consumerSecret
            )
        }
        
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath(
            "oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "cptwitterdemo://oauth"),
            scope: nil,
            success: {
                (requestToken: BDBOAuth1Credential!) -> Void in
                print("got request token")
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                
                UIApplication.sharedApplication().openURL(authURL!)
            },
            failure: {
                (error: NSError!) -> Void in
                print("failed to get token")
            }
        )
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        
        GET("1.1/statuses/home_timeline.json", parameters: nil,
            success: {
                (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                
                completion(tweets: tweets, error: nil)
            },
            failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                self.loginCompletion?(user: nil, error: error)
            }
        )

        
    }
    
    func tweetWithParams(params: NSDictionary?, completion: (result: Tweet?, error: NSError?) -> ()) {
        
        POST("1.1/statuses/update.json", parameters: params,
            success: {
                (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                
                let rs = Tweet(dictionary: response as! NSDictionary)
                completion(result: rs, error: nil)
            },
            failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                
                print("error updating status: \(error)")
            }
        )
    }
    
    func retweetWithParams(id: String, params: NSDictionary?, completion: (result: Tweet?, error: NSError?) -> ()) {
        
        POST("1.1/statuses/retweet/\(id).json", parameters: params,
            success: {
                (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                
                let rs = Tweet(dictionary: response as! NSDictionary)
                completion(result: rs, error: nil)
            },
            failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                
                print("error retweeting: \(error)")
            }
        )
    }
    
    func favorWithParams(params: NSDictionary?, completion: (result: Tweet?, error: NSError?) -> ()) {
        
        POST("1.1/favorites/create.json", parameters: params,
            success: {
                (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                
                let rs = Tweet(dictionary: response as! NSDictionary)
                completion(result: rs, error: nil)
            },
            failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                
                print("error favoring: \(error)")
            }
        )
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath(
            "oauth/access_token",
            method: "POST",
            requestToken: BDBOAuth1Credential(queryString: url.query),
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                print("got access token!")
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil,
                    success: {
                        (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                        let user = User(dictionary: response as! NSDictionary)
                        User.currentUser = user
                        print("user: \(user.name!)")
                        self.loginCompletion?(user: user, error: nil)
                    },
                    failure: {
                        (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                        print("error getting current user")
                        self.loginCompletion?(user: nil, error: error)
                    }
                )
                
                
            },
            failure: { (error: NSError!) -> Void in
                print("failed to receive access token \(error)")
            }
        )
    }
}
