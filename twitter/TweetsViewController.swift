//
//  TweetsViewController.swift
//  twitter
//
//  Created by Shawn Zhu on 9/12/15.
//  Copyright (c) 2015 Shawn Zhu. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion:
            { (tweets, error) -> () in
                if let tweets = tweets {
                    println("tweets \(tweets)")
                } else {
                    println("empty tweets \(error)")
                }
            }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
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
