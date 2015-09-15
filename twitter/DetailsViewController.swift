//
//  DetailsViewController.swift
//  twitter
//
//  Created by Shawn Zhu on 9/13/15.
//  Copyright (c) 2015 Shawn Zhu. All rights reserved.
//

import UIKit

@objc protocol DetailsViewControllerDelegate {
    optional func detailsViewController(viewController: DetailsViewController, didClickReply mode: String)
    optional func detailsViewController(viewController: DetailsViewController, didClickRetweet newtweet: Tweet)
    optional func detailsViewController(viewController: DetailsViewController, didClickFavorite newtweet: Tweet)
}

class DetailsViewController: UIViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favorButton: UIButton!

    var tweet: Tweet?
    weak var delegate: DetailsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let tweet = tweet {
            
            if let user = tweet.user {
                avatarImageView.setImageWithURL(NSURL(string: user.profileImageUrl!))
                avatarImageView.layer.cornerRadius = 5
                avatarImageView.clipsToBounds = true
                
                authorLabel.text = user.name!
                screenNameLabel.text = user.screenName!
                favoriteCountLabel.text = "\(user.favoritedCount)"
            }
            
            tweetLabel.text = tweet.text!
            createdAtLabel.text = tweet.createdAtString
            retweetCountLabel.text = "\(tweet.retweetCount)"
            
            retweetButton.selected = tweet.retweeted!
            favorButton.selected = tweet.favorited!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onHomeClick(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onFavClicked(sender: UIButton) {
        TwitterClient.sharedInstance.favorWithParams([ "id": self.tweet!.statusId ],
            completion: { (result, error) -> () in
                self.delegate?.detailsViewController?(self, didClickFavorite: result!)
                sender.selected = true
        })
    }
    
    @IBAction func onRetweet(sender: UIButton) {
        TwitterClient.sharedInstance.retweetWithParams(self.tweet!.statusId, params: nil) { (result, error) -> () in
            self.delegate?.detailsViewController?(self, didClickRetweet: result!)
            sender.selected = true
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let navigationController = segue.destinationViewController as! UINavigationController
        let vc = navigationController.topViewController as! ComposerViewController
        
        vc.replyToTweet = tweet!
    }


}
