//
//  FQHistoryViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 02/02/2016.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON

class FQHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var businessList: UITableView!
    
    var recentBusiness = [FQTransaction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.getMyAllHistory()
    }
    
    func getMyAllHistory() {
        self.recentBusiness.removeAll()
        SwiftSpinner.show("Fetching..")
        Alamofire.request(Router.getMyAllHistory(user_id: Session.instance.user_id)).responseJSON { response in
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
            for historyData in responseData {
                self.recentBusiness.append(FQTransaction(modelAttr: historyData.1.dictionaryObject!))
            }
            self.businessList.reloadData()
            SwiftSpinner.hide()
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller
        let destView = segue.destinationViewController as! FQRecentViewController
        if let selectedCell = sender as? FQHistoryTableViewCell {
            let indexPath = self.businessList.indexPathForCell(selectedCell)!
            destView.transaction_number = self.recentBusiness[indexPath.row].transaction_number!
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recentBusiness.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FQHistoryTableViewCell") as! FQHistoryTableViewCell
        cell.businessName.text = self.recentBusiness[indexPath.row].business_name
        
        let dateFormatter = NSDateFormatter()
        let stringDate = self.recentBusiness[indexPath.row].date
        let transactionDate = NSDate(timeIntervalSince1970: Double(stringDate!)!)
        dateFormatter.dateStyle = .LongStyle
        cell.dateLastProcessed.text = dateFormatter.stringFromDate(transactionDate)
        
        cell.currentNumber.text = self.recentBusiness[indexPath.row].priority_number
        
        var queueStatus = self.recentBusiness[indexPath.row].status
        if queueStatus == "1" {
            queueStatus = "CALLED"
            cell.status.textColor = UIColor.darkGrayColor()
        }
        else if queueStatus == "2" {
            queueStatus = "SERVED"
            cell.status.textColor = UIColor(red: 0, green: 0.4275, blue: 0.2627, alpha: 1.0) /* #006d43 */
        }
        else if queueStatus == "3" {
            queueStatus = "DROPPED"
            cell.status.textColor = UIColor(red: 0.7176, green: 0, blue: 0, alpha: 1.0) /* #b70000 */
        }
        else {
            queueStatus = "QUEUING"
            cell.status.textColor = UIColor.lightGrayColor()
        }
        cell.status.text = queueStatus
        
        cell.businessLogo.image = UIImage(named: "AboutLogo")
        
        let ratingValue = self.recentBusiness[indexPath.row].rating!
        if ratingValue == "1" {
            cell.ratingBtn1.setImage(UIImage(named: "RatedV2"), forState: .Normal)
        }
        else if ratingValue == "2" {
            cell.ratingBtn1.setImage(UIImage(named: "RatedV2"), forState: .Normal)
            cell.ratingBtn2.setImage(UIImage(named: "RatedV2"), forState: .Normal)
        }
        else if ratingValue == "3" {
            cell.ratingBtn1.setImage(UIImage(named: "RatedV2"), forState: .Normal)
            cell.ratingBtn2.setImage(UIImage(named: "RatedV2"), forState: .Normal)
            cell.ratingBtn3.setImage(UIImage(named: "RatedV2"), forState: .Normal)
        }
        else if ratingValue == "4" {
            cell.ratingBtn1.setImage(UIImage(named: "RatedV2"), forState: .Normal)
            cell.ratingBtn2.setImage(UIImage(named: "RatedV2"), forState: .Normal)
            cell.ratingBtn3.setImage(UIImage(named: "RatedV2"), forState: .Normal)
            cell.ratingBtn4.setImage(UIImage(named: "RatedV2"), forState: .Normal)
        }
        else if ratingValue == "5" {
            cell.ratingBtn1.setImage(UIImage(named: "RatedV2"), forState: .Normal)
            cell.ratingBtn2.setImage(UIImage(named: "RatedV2"), forState: .Normal)
            cell.ratingBtn3.setImage(UIImage(named: "RatedV2"), forState: .Normal)
            cell.ratingBtn4.setImage(UIImage(named: "RatedV2"), forState: .Normal)
            cell.ratingBtn5.setImage(UIImage(named: "RatedV2"), forState: .Normal)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        SwiftSpinner.show("Viewing..")
    }
    
}
