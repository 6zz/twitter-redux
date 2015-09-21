//
//  ProfileViewController.swift
//  twitter
//
//  Created by Shawn Zhu on 9/21/15.
//  Copyright © 2015 Shawn Zhu. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet var taglineLabel: UILabel!
    @IBOutlet weak var followingsLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    
    var user: User! {
        didSet {
            profileImageView.setImageWithURL(NSURL(string: user.profileImageUrl!))
            nameLabel.text = user.name!
            screenNameLabel.text = user.screenName!
            taglineLabel.text = user.tagline!
            followingsLabel.text = "\(user.followingsCount)"
            followersLabel.text = "\(user.followersCount)"
            tweetsLabel.text = "\(user.tweetsCount)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
