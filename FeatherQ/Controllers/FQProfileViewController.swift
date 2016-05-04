//
//  FQAboutViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 02/02/2016.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON

class FQProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var profileData: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.profileData.separatorStyle = .None
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FQProfileTableViewCell") as! FQProfileTableViewCell
        if indexPath.row == 0 {
            cell.profileData.text = Session.instance.firstName + " " + Session.instance.lastName
            cell.profileTitle.text = "Name"
        }
        else if indexPath.row == 1 {
            cell.profileData.text = Session.instance.email
            cell.profileTitle.text = "Email"
        }
        else if indexPath.row == 2 {
            cell.profileData.text = Session.instance.phone
            cell.profileTitle.text = "Phone"
        }
        else if indexPath.row == 3 {
            cell.profileData.text = Session.instance.address
            cell.profileTitle.text = "Address"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func backToSelection(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
