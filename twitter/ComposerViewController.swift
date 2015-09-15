//
//  ComposerViewController.swift
//  twitter
//
//  Created by Shawn Zhu on 9/13/15.
//  Copyright (c) 2015 Shawn Zhu. All rights reserved.
//

import UIKit

@objc protocol ComposerViewControllerDelegate {
    optional func composerViewController(tweeter: ComposerViewController, didTweet tweet: Tweet)
}

class ComposerViewController: UIViewController {

    @IBOutlet weak var tweetButtonItem: UIBarButtonItem!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    
    weak var delegate: ComposerViewControllerDelegate?
    var replyToTweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var user = User.currentUser!
        
        // Do any additional setup after loading the view.
//        self.tweetButtonItem.title = "140 Tweet"
        avatarImageView.setImageWithURL(NSURL(string: user.profileImageUrl!))
        avatarImageView.layer.cornerRadius = 5
        avatarImageView.clipsToBounds = true
        
        nameLabel.text = user.name!
        screenNameLabel.text = user.screenName!
        tweetTextView.text = ""
        if let replyToTweet = replyToTweet {
            tweetTextView.text = "\(replyToTweet.user!.screenName!) "
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onTweet(sender: AnyObject) {
        var params = [ "status": tweetTextView.text ]
        
        if let replyToTweet = replyToTweet {
            params["in_reply_to_status_id"] = replyToTweet.statusId
        }
        
        TwitterClient.sharedInstance.tweetWithParams(
            params,
            completion: { (tweet, error) -> () in
                self.delegate?.composerViewController?(self, didTweet: tweet!)
        })
        
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
