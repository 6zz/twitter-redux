//
//  DetailsViewController.swift
//  twitter
//
//  Created by Shawn Zhu on 9/13/15.
//  Copyright (c) 2015 Shawn Zhu. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoritedImageView: UIImageView!

    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let tweet = tweet {
            
            if let user = tweet.user {
                avatarImageView.setImageWithURL(NSURL(string: user.profileImageUrl!))
                authorLabel.text = user.name!
                screenNameLabel.text = user.screenName!
                favoriteCountLabel.text = "\(user.favoritedCount)"
            }
            
            tweetLabel.text = tweet.text!
            createdAtLabel.text = tweet.createdAtString
            retweetCountLabel.text = "\(tweet.retweetCount)"
            
            if tweet.retweeted! == true {
                retweetImageView.image = UIImage(named: "retweet_on")
            }
            if tweet.favorited! == true {
                favoritedImageView.image = UIImage(named: "favorite_on")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onHomeClick(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
