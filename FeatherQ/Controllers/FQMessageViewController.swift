//
//  FQMessageViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 4/27/16.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit
import SwiftSpinner
import Alamofire
import SwiftyJSON

class FQMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var messageTxt: UITextField!
    @IBOutlet weak var inboxList: UITableView!
    @IBOutlet weak var sendMsgBtn: UIButton!
    
    var business_id = "0"
    var business_name = ""
    var messageData = [["":""]]
    var queuedBusiness = "0"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.inboxList.separatorStyle = .None
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if self.queuedBusiness == self.business_id {
            self.messageTxt.userInteractionEnabled = true
            self.sendMsgBtn.enabled = true
        }
        else {
            self.messageTxt.userInteractionEnabled = false
            self.sendMsgBtn.enabled = false
            self.messageTxt.placeholder = "Allowed only to currently lined up business."
        }
        self.navigationItem.title = self.business_name
        self.getBusinessMessages(Session.instance.fb_id, business_id: self.business_id)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.messageData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FQInboxTableViewCell", forIndexPath: indexPath) as! FQInboxTableViewCell
        
        // Configure the cell...
        if self.messageData[indexPath.row]["sender"] == "business" {
            cell.fromBusiness.hidden = false
            cell.fromYou.hidden = true
            cell.businessBubble.hidden = false
            cell.userBubble.hidden = true
            cell.fromBusiness.text = self.messageData[indexPath.row]["contmessage"]
        }
        else {
            cell.fromBusiness.hidden = true
            cell.fromYou.hidden = false
            cell.businessBubble.hidden = true
            cell.userBubble.hidden = false
            cell.fromYou.text = self.messageData[indexPath.row]["contmessage"]
        }
        
        return cell
    }
    
    @IBAction func sendMessage(sender: AnyObject) {
//        let alertBox = UIAlertController(title: "Confirm", message: "Do you want to send the message now?", preferredStyle: .Alert)
//        alertBox.addAction(UIAlertAction(title: "YES", style: .Default, handler: { (action: UIAlertAction!) in
//            self.postSendMessage(Session.instance.user_id, business_id: self.business_id, message: self.messageTxt.text!)
//        }))
//        alertBox.addAction(UIAlertAction(title: "NO", style: .Default, handler: nil))
//        self.presentViewController(alertBox, animated: true, completion: nil)
        self.postSendMessage(Session.instance.user_id, business_id: self.business_id, message: self.messageTxt.text!)
    }
    
    func postSendMessage(user_id: String, business_id: String, message: String) {
        SwiftSpinner.show("Sending message..")
        Alamofire.request(Router.postSendMessage(user_id: user_id, business_id: business_id, message: message)).responseJSON { response in
            if response.result.isFailure {
                debugPrint(response.result.error)
                let errorMessage = (response.result.error?.localizedDescription)! as String
                SwiftSpinner.show(errorMessage, animated: false).addTapHandler({
                    SwiftSpinner.hide()
                })
                return
            }
            let responseData = JSON(data: response.data!)
            debugPrint(responseData)
            self.messageTxt.text = ""
            self.getBusinessMessages(Session.instance.fb_id, business_id: self.business_id)
        }
    }
    
    func getBusinessMessages(facebook_id: String, business_id: String) {
        SwiftSpinner.show("Fetching..")
        self.messageData.removeAll()
        Alamofire.request(Router.getBusinessMessages(facebookId: facebook_id, businessId: business_id)).responseJSON { response in
            if response.result.isFailure {
                debugPrint(response.result.error)
                let errorMessage = (response.result.error?.localizedDescription)! as String
                SwiftSpinner.show(errorMessage, animated: false).addTapHandler({
                    SwiftSpinner.hide()
                })
                return
            }
            let responseData = JSON(data: response.data!)
            debugPrint(responseData)
            for messageList in responseData["messages"] {
                let dataObj = messageList.1.dictionaryObject!
                self.messageData.append([
                    "timestamp": "\(dataObj["timestamp"]!)",
                    "contmessage": dataObj["contmessage"] as! String,
                    "sender": dataObj["sender"] as! String
                    ])
            }
            debugPrint(self.messageData)
            self.inboxList.reloadData()
            let cgpoint = self.inboxList.contentSize.height - self.inboxList.frame.size.height
            self.inboxList.setContentOffset(CGPointMake(0, cgpoint), animated: false)
            SwiftSpinner.hide()
        }
    }

}
