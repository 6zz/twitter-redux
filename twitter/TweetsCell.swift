//
//  TweetsCell.swift
//  twitter
//
//  Created by Shawn Zhu on 9/13/15.
//  Copyright (c) 2015 Shawn Zhu. All rights reserved.
//

import UIKit

class TweetsCell: UITableViewCell {

    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var mentionLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    var dateFormatter = NSDateFormatter()
    
    var tweet: Tweet! {
        didSet {
            authorImageView.setImageWithURL(NSURL(string: tweet.user!.profileImageUrl!))
            authorLabel.text = tweet.user!.name
            
            var hoursAgo = Int(ceil(abs(tweet.createdAt!.timeIntervalSinceNow)/3600))

            if hoursAgo < 24 {
                createdAtLabel.text = "\(hoursAgo)h"
            } else {
                dateFormatter.dateFormat = "m/d/y"
                createdAtLabel.text = dateFormatter.stringFromDate(tweet.createdAt!)
            }
            
            tweetLabel.text = tweet.text!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        preferredMaxLayoutWidth()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        authorImageView.layer.cornerRadius = 5
        authorImageView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.preferredMaxLayoutWidth()
    }
    
    private func preferredMaxLayoutWidth() {
        authorLabel.preferredMaxLayoutWidth = authorLabel.frame.size.width
        mentionLabel.preferredMaxLayoutWidth = mentionLabel.frame.size.width
        tweetLabel.preferredMaxLayoutWidth = tweetLabel.frame.size.width
    }

}
