//
//  MenuViewController.swift
//  twitter
//
//  Created by Shawn Zhu on 9/19/15.
//  Copyright © 2015 Shawn Zhu. All rights reserved.
//


import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var loginNavigationController: UIViewController!
    private var tweetsNavigationController: UIViewController!
//    private var pinkNavigationController: UIViewController!
    
    var viewControllers: [UIViewController] = []
    
    var hamburgerViewController: HamburgerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        loginNavigationController = storyboard.instantiateViewControllerWithIdentifier("LoginNavigationController")
        tweetsNavigationController = storyboard.instantiateViewControllerWithIdentifier("TweetsNavController")
        //pinkNavigationController = storyboard.instantiateViewControllerWithIdentifier("PinkNavigationController")
        
        viewControllers.append(loginNavigationController)
        viewControllers.append(tweetsNavigationController)
//        viewControllers.append(pinkNavigationController)
        
        if User.currentUser != nil {
            print("current user detected")
            let vc: UIViewController = storyboard.instantiateViewControllerWithIdentifier("TweetsNavController") as! UINavigationController
            
            hamburgerViewController?.contentViewController = vc
        } else {
            hamburgerViewController?.contentViewController = loginNavigationController
        }
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

extension MenuViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
        
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        hamburgerViewController?.contentViewController = viewControllers[indexPath.row]
    }
}
