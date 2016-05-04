//
//  FQMoreTableViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 5/2/16.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class FQMoreTableViewController: UITableViewController {

    @IBOutlet weak var fullName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.separatorStyle = .None
        self.fullName.text = "Hi, " + Session.instance.firstName + "!"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            let vc = UIStoryboard(name: "Main",bundle: nil).instantiateViewControllerWithIdentifier("FQProfile")
            self.presentViewController(vc, animated: true, completion: nil)
        }
        else if indexPath.row == 2 {
            let vc = UIStoryboard(name: "Main",bundle: nil).instantiateViewControllerWithIdentifier("FQAbout")
            self.presentViewController(vc, animated: true, completion: nil)
        }
        else if indexPath.row == 3 {
            let alertBox = UIAlertController(title: "Confirm", message: "Are you sure you want to logout?", preferredStyle: .Alert)
            alertBox.addAction(UIAlertAction(title: "YES", style: .Default, handler: { (action: UIAlertAction!) in
                let loginManager: FBSDKLoginManager = FBSDKLoginManager()
                loginManager.logOut()
                self.view.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FQIntroContainerViewController")
            }))
            alertBox.addAction(UIAlertAction(title: "NO", style: .Default, handler: nil))
            self.presentViewController(alertBox, animated: true, completion: nil)
            return
        }
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
