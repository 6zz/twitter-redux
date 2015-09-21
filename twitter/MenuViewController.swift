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
    private var profileNavigationController: UIViewController!
    private var tweetsNavigationController: UIViewController!
//    private var pinkNavigationController: UIViewController!
    
    var viewControllers: [UIViewController] = []
    
    var hamburgerViewController: HamburgerViewController?
    var links = ["Time Line", "Mentions"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        loginNavigationController = storyboard.instantiateViewControllerWithIdentifier("LoginNavigationController")
        profileNavigationController = storyboard.instantiateViewControllerWithIdentifier("ProfileNavigationController")
        tweetsNavigationController = storyboard.instantiateViewControllerWithIdentifier("TweetsNavController")
        //pinkNavigationController = storyboard.instantiateViewControllerWithIdentifier("PinkNavigationController")
        
        viewControllers.append(profileNavigationController)
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
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("MenuProfileCell") as! MenuProfileCell
            cell.user = User.currentUser
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
            cell.setLink(links[indexPath.row])
            return cell
        }
    }
}

extension MenuViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let section = indexPath.section
        
        if section == 0 {
            let profileNavigationController = viewControllers[indexPath.row] as! UINavigationController
            let profileViewController = profileNavigationController.topViewController as! ProfileViewController

            profileViewController.user = User.currentUser!
            hamburgerViewController?.contentViewController = profileNavigationController
        } else {
            hamburgerViewController?.contentViewController = viewControllers[indexPath.row+1]
        }
    }
}
