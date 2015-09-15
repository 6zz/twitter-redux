//
//  TweetsCell.swift
//  twitter
//
//  Created by Shawn Zhu on 9/13/15.
//  Copyright (c) 2015 Shawn Zhu. All rights reserved.
//

import UIKit

@objc protocol TweetsCellDelegate {
    optional func tweetsCell(cell: TweetsCell, didClickReply mode: String)
}

class TweetsCell: UITableViewCell {

    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var mentionLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    var dateFormatter = NSDateFormatter()
    weak var delegate: TweetsCellDelegate?
    
    var tweet: Tweet! {
        didSet {
            var user = tweet.user!
            
            authorImageView.setImageWithURL(NSURL(string: tweet.user!.profileImageUrl!))
            authorLabel.text = user.name!
            mentionLabel.text = user.screenName!
            
            var hoursAgo = Int(ceil(abs(tweet.createdAt!.timeIntervalSinceNow)/3600))

            if hoursAgo < 24 {
                createdAtLabel.text = "\(hoursAgo)h"
            } else {
                dateFormatter.dateFormat = "m/d/y"
                createdAtLabel.text = dateFormatter.stringFromDate(tweet.createdAt!)
            }
            
            tweetLabel.text = tweet.text!
            println("retweeted: \(tweet.retweeted!); favrited: \(tweet.favorited!)")
            if tweet.retweeted! == true {
                retweetButton.setImage(UIImage(named: "retweet_on"), forState: UIControlState.Normal)
            }
            if tweet.favorited! == true {
                favoriteButton.setImage(UIImage(named: "favorite_on"), forState: UIControlState.Normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        preferredMaxLayoutWidth()
        authorImageView.layer.cornerRadius = 5
        authorImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.preferredMaxLayoutWidth()
    }
    
    @IBAction func onReply(sender: AnyObject) {
        delegate?.tweetsCell?(self, didClickReply: "reply")
    }
    
    private func preferredMaxLayoutWidth() {
        authorLabel.preferredMaxLayoutWidth = authorLabel.frame.size.width
        mentionLabel.preferredMaxLayoutWidth = mentionLabel.frame.size.width
        tweetLabel.preferredMaxLayoutWidth = tweetLabel.frame.size.width
    }

}
