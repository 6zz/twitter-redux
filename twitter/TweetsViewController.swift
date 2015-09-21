//
//  TweetsViewController.swift
//  twitter
//
//  Created by Shawn Zhu on 9/12/15.
//  Copyright (c) 2015 Shawn Zhu. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    @IBOutlet weak var tableView: UITableView!
 
    var refreshControl: UIRefreshControl!
    var tweets: [Tweet]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchTweets", forControlEvents: UIControlEvents.ValueChanged)
        
        let dummyTableVC = UITableViewController()
        dummyTableVC.tableView = tableView
        dummyTableVC.refreshControl = refreshControl
        
        fetchTweets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func fetchTweets() {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion:
            { (tweets, error) -> () in
                if let tweets = tweets {
                    self.tweets = tweets
                    self.tableView.reloadData()
                } else {
                    print("empty tweets \(error)")
                }
                self.refreshControl.endRefreshing()
            }
        )
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetsCell", forIndexPath: indexPath) as! TweetsCell
        
        if let tweets = tweets {
            cell.tweet = tweets[indexPath.row]
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
    @IBAction func onSignOut(sender: AnyObject) {
        User.currentUser?.logout()
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let vc = navigationController.topViewController! as UIViewController
        
        switch segue.identifier! {
        case "newTweetSegue":
            self.prepareForSegueToComposerView(
                sender,
                viewController: vc as! ComposerViewController
            )
        case "detailsSegue":
            self.prepareForSegueToDetailsView(
                sender as! UITableViewCell,
                viewController: vc as! DetailsViewController
            )
        default:
            print("unhandled segue")
        }
        
    }
    
    func prepareForSegueToDetailsView(cell: UITableViewCell, viewController: DetailsViewController) {
        let indexPath = tableView.indexPathForCell(cell)!
        let tweet = self.tweets![indexPath.row]
        
        viewController.tweet = tweet
        viewController.delegate = self
    }
    
    func prepareForSegueToComposerView(
        sender: AnyObject?,
        viewController: ComposerViewController
        ) {
            viewController.delegate = self
            viewController.replyToTweet = sender?.tweet
    }
    


}

extension TweetsViewController: ComposerViewControllerDelegate {
    
    func composerViewController(tweeter: ComposerViewController, didTweet tweet: Tweet) {
        if tweets == nil {
            tweets = [Tweet]()
        }
        
        tweets!.insert(tweet, atIndex: 0)
        tableView.reloadData()
    }
}

extension TweetsViewController: TweetsCellDelegate {
    func tweetsCell(cell: TweetsCell, didClickReply mode: String) {
        performSegueWithIdentifier("newTweetSegue", sender: cell)
    }
    
    func tweetsCell(cell: TweetsCell, didClickRetweet newtweet: Tweet) {
        if tweets == nil {
            tweets = [Tweet]()
        }
        
        tweets!.insert(newtweet, atIndex: 0)
        tableView.reloadData()
    }
}


extension TweetsViewController: DetailsViewControllerDelegate {
    func detailsViewController(viewController: DetailsViewController, didClickRetweet newtweet: Tweet) {
        if tweets == nil {
            tweets = [Tweet]()
        }
        
        tweets!.insert(newtweet, atIndex: 0)
        tableView.reloadData()
    }
}