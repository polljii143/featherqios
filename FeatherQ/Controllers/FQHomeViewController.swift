//
//  FQHomeViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 24/01/2016.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import CoreLocation

class FQHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()

    @IBOutlet weak var tableView: UITableView!
    var filterSearch = UISearchController()
    var recentBusiness = [FQTransaction]()
    var otherBusiness = [FQBusiness]()
    var activeBusiness = [FQBusiness]()
    var nowServing = [String]()
    var filteredBusinesses = [String]()
    var queueInfo = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.filterSearch = UISearchController(searchResultsController: nil)
        self.filterSearch.searchResultsUpdater = self
        self.filterSearch.dimsBackgroundDuringPresentation = false
        self.filterSearch.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.filterSearch.searchBar
        //self.getPopularBusiness()
        //self.getMyHistory()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.getUserQueue()
    }
    
    func getUserQueue() {
        SwiftSpinner.show("Fetching..");
        Alamofire.request(Router.getUserQueue(userId: Session.instance.userId)).responseJSON { response in
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
            if dataObj.isEmpty {
                Session.instance.inQueue = false
                self.getActiveBusinesses()
            }
            else {
                Session.instance.inQueue = true
                self.queueInfo["transaction_number"] = "\(dataObj["transaction_number"]!)"
                self.queueInfo["business_id"] = "\(dataObj["business"]!["id"]!!)"
                self.queueInfo["business_name"] = dataObj["business"]!["name"] as? String
                self.queueInfo["business_address"] = dataObj["business"]!["address"] as? String
                self.queueInfo["priority_number"] = dataObj["priority_number"] as? String
                self.queueInfo["estimated_time_left"] = "\(dataObj["estimated_time_left"]!)"
                self.queueInfo["last_called_number"] = dataObj["business"]!["last_called"]!!["queue_number"] as? String
                self.queueInfo["last_called_service"] = dataObj["business"]!["last_called"]!!["service_name"] as? String
                self.getCheckedIn(self.queueInfo["transaction_number"]!)
            }
        }
    }
    
    func getCheckedIn(transactionNumber: String) {
        Alamofire.request(Router.getCheckedIn(transactionNumber: transactionNumber)).responseJSON { response in
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
            let dataObj = responseData.dictionaryObject!
            let checkInStatus = dataObj["is_checked_in"] as! Bool
            if checkInStatus {
                Session.instance.checkedIn = true
            }
            else {
                Session.instance.checkedIn = false
                //self.checkInStatus.backgroundColor = UIColor(red: 0.7176, green: 0, blue: 0, alpha: 1.0) /* #b70000 */
            }
            self.getActiveBusinesses()
        }
    }
    
    func getActiveBusinesses() {
        self.activeBusiness.removeAll()
        Alamofire.request(Router.getActiveBusinesses).responseJSON { response in
            if response.result.isFailure {
                debugPrint(response.result.error)
                let errorMessage = (response.result.error?.localizedDescription)! as String
                SwiftSpinner.show(errorMessage, animated: false).addTapHandler({
                    SwiftSpinner.hide()
                })
                return
            }
            let responseData = JSON(data: response.data!)
            for businessData in responseData {
                let dataObj = businessData.1.dictionaryObject!
                let lastCalled = dataObj["last_called_array"]
                var lastCalledNumber = " "
                var lastCalledService = " "
                if lastCalled!.count > 0 {
                    lastCalledNumber = lastCalled!["queue_number"] as! String
                    lastCalledService = lastCalled!["service_name"] as! String
                }
                if self.queueInfo["business_id"] != "\(dataObj["id"]!)" {
                    self.activeBusiness.append(FQBusiness(modelAttr: [
                        "business_id": "\(dataObj["id"]!)",
                        "name": dataObj["name"] as! String,
                        "local_address": dataObj["address"] as! String,
                        "latitude": 0,
                        "longitude": 0,
                        "distance": 0,
                        "last_called_number": lastCalledNumber,
                        "last_called_service": lastCalledService
                    ]))
                }
            }
            self.getAllBusiness()
        }
    }
    
    func getAllBusiness() {
        self.otherBusiness.removeAll()
        Alamofire.request(Router.getAllBusiness).responseJSON { response in
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
            for businessData in responseData["search-result"] {
                let dataObj = businessData.1.dictionaryObject!
                if self.queueInfo["business_id"] != "\(dataObj["business_id"]!)" {
                    self.otherBusiness.append(FQBusiness(modelAttr: [
                        "business_id": "\(dataObj["business_id"]!)",
                        "name": dataObj["name"] as! String,
                        "local_address": dataObj["local_address"] as! String,
                        "latitude": 0,
                        "longitude": 0,
                        "distance": 0,
                        "last_called_number": " ",
                        "last_called_service": " "
                    ]))
                }
            }
            self.tableView.reloadData()
            SwiftSpinner.hide()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "composeMessage" {
            let destView = segue.destinationViewController as! FQMessageViewController
            destView.businessId = self.queueInfo["business_id"]!
            destView.businessName = self.queueInfo["business_name"]!
            destView.queuedBusiness = self.queueInfo["business_id"]!
        }
        else if segue.identifier == "showQueuedBroadcast" {
            debugPrint(self.queueInfo["business_id"]!)
            let destView = segue.destinationViewController as! FQRemoteViewController
            destView.transactionNumber = self.queueInfo["transaction_number"]!
            destView.chosenBusiness = FQBusiness(modelAttr: [
                "business_id": self.queueInfo["business_id"]!,
                "name": self.queueInfo["business_name"]!,
                "local_address": self.queueInfo["business_address"]!,
                "latitude": 0,
                "longitude": 0,
                "distance": 0,
                "last_called_number": self.queueInfo["last_called_number"]!,
                "last_called_service": self.queueInfo["last_called_service"]!
            ])
        }
        else if segue.identifier == "qrCodeScanner" {
            // Do nothing if QR code scanner is invoked
        }
        else {
            let selectedCell = sender as? FQHomeTableViewCell
            let indexPath = tableView.indexPathForCell(selectedCell!)!
            let destView = segue.destinationViewController as! FQBusinessViewController
            if self.filterSearch.active {
                let businessData = self.filteredBusinesses[indexPath.row].componentsSeparatedByString("|")
                destView.chosenBusiness = FQBusiness(modelAttr: [
                    "business_id": businessData[3],
                    "name": businessData[0],
                    "local_address": businessData[1],
                    "longitude": 0,
                    "latitude": 0,
                    "distance": businessData[2].stringByReplacingOccurrencesOfString(",", withString: ""),
                ])
                self.filterSearch.active = false
            }
            else {
                if Session.instance.inQueue {
                    if indexPath.section == 0 {
                        
                    }
                    else if indexPath.section == 1 {
                        destView.chosenBusiness = self.activeBusiness[indexPath.row]
                    }
                    else {
                        destView.chosenBusiness = self.otherBusiness[indexPath.row]
                    }
                }
                else {
                    if indexPath.section == 0 {
                        destView.chosenBusiness = self.activeBusiness[indexPath.row]
                    }
                    else {
                        destView.chosenBusiness = self.otherBusiness[indexPath.row]
                    }
                }
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.filterSearch.active {
            return 1
        }
        else if Session.instance.inQueue {
            return 3
        }
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.filterSearch.active {
            return self.filteredBusinesses.count
        }
        else {
            if Session.instance.inQueue {
                if section == 0 {
                    return 1
                }
                else if section == 1 {
                    return self.activeBusiness.count
                }
                else {
                    return self.otherBusiness.count
                }
            }
            else {
                if section == 0 {
                    return self.activeBusiness.count
                }
                else {
                    return self.otherBusiness.count
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if Session.instance.inQueue && indexPath.section == 0 && !self.filterSearch.active {
            return 285.0
        }
        return 120.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.filterSearch.active {
            let cell = tableView.dequeueReusableCellWithIdentifier("FQHomeTableViewCell") as! FQHomeTableViewCell
            cell.servingLabel.hidden = false
            let businessData = self.filteredBusinesses[indexPath.row].componentsSeparatedByString("|")
            cell.businessLogo.image = UIImage(named: "AboutLogo")
            cell.businessName.text = businessData[0]
            cell.businessAddress.text = businessData[1]
            let lastCalledService = businessData[4]
            let lastCalledNumber = businessData[5]
            if lastCalledNumber == " " {
                cell.servingLabel.hidden = true
            }
            cell.nowServing.text = lastCalledNumber
            cell.serviceName.text = lastCalledService
            return cell
        }
        else {
            if Session.instance.inQueue {
                if indexPath.section == 0 {
                    let cell = tableView.dequeueReusableCellWithIdentifier("FQHomeCurrentTableViewCell") as! FQHomeCurrentTableViewCell
                    if !self.queueInfo.isEmpty {
                        cell.businessName.text = self.queueInfo["business_name"]
                        cell.businessAddress.text = self.queueInfo["business_address"]
                        cell.nowServing.text = self.queueInfo["last_called_service"]!
                        cell.currentNum.text = self.queueInfo["last_called_number"]!
                        cell.timeLeft.text = self.queueInfo["estimated_time_left"]! + " mins left"
                        cell.yourNumber.text = self.queueInfo["priority_number"]
                    }
                    if Session.instance.checkedIn {
                        cell.checkInBtn.enabled = false
                        cell.checkInLbl.font = UIFont.boldSystemFontOfSize(13)
                        cell.checkInLbl.text = "You are now checked in."
                        cell.checkInLbl.textColor = UIColor.whiteColor()
                        cell.checkInLbl.backgroundColor = UIColor(red: 0, green: 0.7294, blue: 0.5451, alpha: 1.0) /* #00ba8b */
                    }
                    else {
                        cell.checkInBtn.enabled = true
                        cell.checkInLbl.text = "Check-In"
                        cell.checkInLbl.font = UIFont.systemFontOfSize(11)
                        cell.checkInLbl.textColor = UIColor.blackColor()
                        cell.checkInLbl.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0) /* #ffffff */
                    }
                    return cell
                }
                else if indexPath.section == 1 {
                    let cell = tableView.dequeueReusableCellWithIdentifier("FQHomeTableViewCell") as! FQHomeTableViewCell
                    cell.servingLabel.hidden = false
                    cell.businessLogo.image = UIImage(named: "AboutLogo")
                    cell.businessName.text = self.activeBusiness[indexPath.row].name
                    cell.businessAddress.text = self.activeBusiness[indexPath.row].localAddress
                    var lastCalledService = self.activeBusiness[indexPath.row].lastCalledService
                    var lastCalledNumber = self.activeBusiness[indexPath.row].lastCalledNumber
                    if lastCalledService == nil {
                        lastCalledService = " "
                    }
                    if lastCalledNumber == nil {
                        lastCalledNumber = " "
                    }
                    cell.nowServing.text = lastCalledNumber!
                    cell.serviceName.text = lastCalledService!
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCellWithIdentifier("FQHomeTableViewCell") as! FQHomeTableViewCell
                    cell.servingLabel.hidden = true
                    cell.businessLogo.image = UIImage(named: "AboutLogo")
                    cell.businessName.text = self.otherBusiness[indexPath.row].name
                    cell.businessAddress.text = self.otherBusiness[indexPath.row].localAddress
                    var lastCalledService = self.otherBusiness[indexPath.row].lastCalledService
                    var lastCalledNumber = self.otherBusiness[indexPath.row].lastCalledNumber
                    if lastCalledService == nil {
                        lastCalledService = " "
                    }
                    if lastCalledNumber == nil {
                        lastCalledNumber = " "
                    }
                    cell.nowServing.text = lastCalledNumber!
                    cell.serviceName.text = lastCalledService!
                    return cell
                }
            }
            else {
                let cell = tableView.dequeueReusableCellWithIdentifier("FQHomeTableViewCell") as! FQHomeTableViewCell
                if indexPath.section == 0 {
                    cell.servingLabel.hidden = false
                    cell.businessLogo.image = UIImage(named: "AboutLogo")
                    cell.businessName.text = self.activeBusiness[indexPath.row].name
                    cell.businessAddress.text = self.activeBusiness[indexPath.row].localAddress
                    var lastCalledService = self.activeBusiness[indexPath.row].lastCalledService
                    var lastCalledNumber = self.activeBusiness[indexPath.row].lastCalledNumber
                    if lastCalledService == nil {
                        lastCalledService = " "
                    }
                    if lastCalledNumber == nil {
                        lastCalledNumber = " "
                    }
                    cell.nowServing.text = lastCalledNumber!
                    cell.serviceName.text = lastCalledService!
                }
                else {
                    cell.servingLabel.hidden = true
                    cell.businessLogo.image = UIImage(named: "AboutLogo")
                    cell.businessName.text = self.otherBusiness[indexPath.row].name
                    cell.businessAddress.text = self.otherBusiness[indexPath.row].localAddress
                    var lastCalledService = self.otherBusiness[indexPath.row].lastCalledService
                    var lastCalledNumber = self.otherBusiness[indexPath.row].lastCalledNumber
                    if lastCalledService == nil {
                        lastCalledService = " "
                    }
                    if lastCalledNumber == nil {
                        lastCalledNumber = " "
                    }
                    cell.nowServing.text = lastCalledNumber!
                    cell.serviceName.text = lastCalledService!
                }
                return cell
            }
        }
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        //SwiftSpinner.show("Viewing..")
        return indexPath
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        var unwrappedBusinessNames = [String]()
        for business in self.otherBusiness {
            unwrappedBusinessNames.append(business.name!+"|"+business.localAddress!+"|"+business.distance!+"|"+business.businessId!+"|"+business.lastCalledService!+"|"+business.lastCalledNumber!)
        }
        self.filteredBusinesses.removeAll(keepCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (unwrappedBusinessNames as NSArray).filteredArrayUsingPredicate(searchPredicate)
        self.filteredBusinesses = array as! [String]
        self.tableView.reloadData()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                debugPrint(error?.localizedDescription)
            }
            if placemarks!.count > 0 {
                self.locationManager.stopUpdatingLocation()
                Session.instance.latitude = self.locationManager.location!.coordinate.latitude // save the current location
                Session.instance.longitude = self.locationManager.location!.coordinate.longitude // save the current location
                debugPrint(Session.instance.latitude)
                debugPrint(Session.instance.longitude)
                debugPrint(placemarks![0].subLocality)
                debugPrint(placemarks![0].locality)
                debugPrint(placemarks![0].country)
            }
        })
    }
    
    @IBAction func checkIn(sender: AnyObject) {
        let alertBox = UIAlertController(title: "Confirm", message: "Do you want to check-in now?", preferredStyle: .Alert)
        alertBox.addAction(UIAlertAction(title: "YES", style: .Default, handler: { (action: UIAlertAction!) in
            self.getCheckinTransaction(self.queueInfo["transaction_number"]!)
        }))
        alertBox.addAction(UIAlertAction(title: "NO", style: .Default, handler: nil))
        self.presentViewController(alertBox, animated: true, completion: nil)
    }
    
    @IBAction func composeMessage(sender: AnyObject) {
    }
    
    func getCheckinTransaction(transactionNumber: String) {
        SwiftSpinner.show("Checking in..")
        Alamofire.request(Router.getCheckinTransaction(transactionNumber: transactionNumber)).responseJSON { response in
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
            Session.instance.checkedIn = true
            self.tableView.reloadData()
            SwiftSpinner.hide()
        }
    }
}
