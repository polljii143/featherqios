//
//  FQRecentViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 03/02/2016.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON

class FQRecentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var yourNumber: UILabel!
    @IBOutlet weak var transactionData: UITableView!
    @IBOutlet weak var ratingBtn1: UIButton!
    @IBOutlet weak var ratingBtn2: UIButton!
    @IBOutlet weak var ratingBtn3: UIButton!
    @IBOutlet weak var ratingBtn4: UIButton!
    @IBOutlet weak var ratingBtn5: UIButton!
    @IBOutlet weak var fullDate: UILabel!
    @IBOutlet weak var queueStatus: UILabel!
    
    var ratingValue = "0"
    var name = " "
    var businessAddress = " "
    var businessStatus = "0"
    var priorityNumber = "0"
    var timeIssued = "0"
    var timeCalled = "0"
    var transactionNumber = "0"
    var transactionDate = "0"
    var businessId = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.getMyBusinessHistory(self.transactionNumber)
    }
    
    func getMyBusinessHistory(transactionNumber: String) {
        SwiftSpinner.show("Fetching..")
        Alamofire.request(Router.getMyBusinessHistory(transactionNumber: transactionNumber)).responseJSON { response in
            if response.result.isFailure {
                debugPrint(response.result.error)
                let errorMessage = (response.result.error?.localizedDescription)! as String
                SwiftSpinner.show(errorMessage, animated: false).addTapHandler({
                    SwiftSpinner.hide()
                })
                return
            }
            let responseData = JSON(data: response.data!)
            let dataObj = responseData.dictionaryObject!
            debugPrint(responseData)
            self.address.text = dataObj["address"] as? String
            self.businessName.text = dataObj["business_name"] as? String
            self.businessStatus = "\(dataObj["status"]!)"
            self.yourNumber.text = dataObj["priority_number"] as? String
            self.timeIssued = "\(dataObj["time_issued"]!)"
            self.timeCalled = "\(dataObj["time_called"]!)"
            self.ratingValue = "\(dataObj["rating"]!)"
            self.transactionDate = "\(dataObj["transaction_date"]!)"
            self.businessId = "\(dataObj["business_id"]!)"
            self.renderHistoryData()
            SwiftSpinner.hide()
        }
    }
    
    func renderHistoryData() {
        self.ratedButtonsChange(self.ratingValue)
        
        let dateFormatter = NSDateFormatter()
        let stringDate = self.transactionDate
        let transactionDate = NSDate(timeIntervalSince1970: Double(stringDate)!)
        dateFormatter.dateStyle = .LongStyle
        self.fullDate.text = dateFormatter.stringFromDate(transactionDate)
        
        var queueStatus = self.businessStatus
        if queueStatus == "1" {
            queueStatus = "CALLED"
            self.queueStatus.textColor = UIColor.darkGrayColor()
        }
        else if queueStatus == "2" {
            queueStatus = "SERVED"
            self.queueStatus.textColor = UIColor(red: 0, green: 0.4275, blue: 0.2627, alpha: 1.0) /* #006d43 */
        }
        else if queueStatus == "3" {
            queueStatus = "DROPPED"
            self.queueStatus.textColor = UIColor(red: 0.7176, green: 0, blue: 0, alpha: 1.0) /* #b70000 */
        }
        else {
            queueStatus = "QUEUING"
            self.queueStatus.textColor = UIColor.lightGrayColor()
        }
        self.queueStatus.text = queueStatus
        
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
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FQProfileTableViewCell") as! FQProfileTableViewCell
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        if indexPath.row == 0 {
            let transactionDate = NSDate(timeIntervalSince1970: Double(self.timeIssued)!)
            cell.profileData.text = dateFormatter.stringFromDate(transactionDate)
            cell.profileTitle.text = "Queued"
        }
        else if indexPath.row == 1 {
            let transactionDate = NSDate(timeIntervalSince1970: Double(self.timeCalled)!)
            cell.profileData.text = dateFormatter.stringFromDate(transactionDate)
            cell.profileTitle.text = "Called"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 59.0
    }

    @IBAction func rating1(sender: AnyObject) {
        self.getRateBusiness("1", fbId: Session.instance.fbId, businessId: self.businessId, transactionNumber: self.transactionNumber)
        self.ratedButtonsChange("1")
    }
    @IBAction func rating2(sender: AnyObject) {
        self.getRateBusiness("2", fbId: Session.instance.fbId, businessId: self.businessId, transactionNumber: self.transactionNumber)
        self.ratedButtonsChange("2")
    }
    @IBAction func rating3(sender: AnyObject) {
        self.getRateBusiness("3", fbId: Session.instance.fbId, businessId: self.businessId, transactionNumber: self.transactionNumber)
        self.ratedButtonsChange("3")
    }
    @IBAction func rating4(sender: AnyObject) {
        self.getRateBusiness("4", fbId: Session.instance.fbId, businessId: self.businessId, transactionNumber: self.transactionNumber)
        self.ratedButtonsChange("4")
    }
    @IBAction func rating5(sender: AnyObject) {
        self.getRateBusiness("5", fbId: Session.instance.fbId, businessId: self.businessId, transactionNumber: self.transactionNumber)
        self.ratedButtonsChange("5")
    }
    
    func ratedButtonsChange(ratingValue: String) {
        if ratingValue == "1" {
            self.ratingBtn1.setBackgroundImage(UIImage(named: "Rated"), forState: .Normal)
        }
        else if ratingValue == "2" {
            self.ratingBtn1.setBackgroundImage(UIImage(named: "Rated"), forState: .Normal)
            self.ratingBtn2.setBackgroundImage(UIImage(named: "Rated"), forState: .Normal)
        }
        else if ratingValue == "3" {
            self.ratingBtn1.setBackgroundImage(UIImage(named: "Rated"), forState: .Normal)
            self.ratingBtn2.setBackgroundImage(UIImage(named: "Rated"), forState: .Normal)
            self.ratingBtn3.setBackgroundImage(UIImage(named: "Rated"), forState: .Normal)
        }
        else if ratingValue == "4" {
            self.ratingBtn1.setBackgroundImage(UIImage(named: "Rated"), forState: .Normal)
            self.ratingBtn2.setBackgroundImage(UIImage(named: "Rated"), forState: .Normal)
            self.ratingBtn3.setBackgroundImage(UIImage(named: "Rated"), forState: .Normal)
            self.ratingBtn4.setBackgroundImage(UIImage(named: "Rated"), forState: .Normal)
        }
        else if ratingValue == "5" {
            self.ratingBtn1.setBackgroundImage(UIImage(named: "Rated"), forState: .Normal)
            self.ratingBtn2.setBackgroundImage(UIImage(named: "Rated"), forState: .Normal)
            self.ratingBtn3.setBackgroundImage(UIImage(named: "Rated"), forState: .Normal)
            self.ratingBtn4.setBackgroundImage(UIImage(named: "Rated"), forState: .Normal)
            self.ratingBtn5.setBackgroundImage(UIImage(named: "Rated"), forState: .Normal)
        }
    }
    
    func getRateBusiness(rating: String, fbId: String, businessId: String, transactionNumber: String) {
        Alamofire.request(Router.getRateBusiness(rating: rating, facebookId: fbId, businessId: businessId, transactionNumber: transactionNumber)).responseJSON { response in
            if response.result.isFailure {
                debugPrint(response.result.error)
                let errorMessage = (response.result.error?.localizedDescription)! as String
                SwiftSpinner.show(errorMessage, animated: false).addTapHandler({
                    SwiftSpinner.hide()
                })
                return
            }
        }
    }
}
