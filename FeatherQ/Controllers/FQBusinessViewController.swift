//
//  FQBusinessViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 03/02/2016.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit
import SwiftSpinner
import SwiftyJSON
import Alamofire
import AVFoundation

class FQBusinessViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var broadcastNumbers: UICollectionView!
    @IBOutlet weak var serviceList: UITableView!
    @IBOutlet weak var tickerNotes: UILabel!
    
    var chosenBusiness: FQBusiness?
    var numBoxes = 0
    var newNumbers = [String]()
    var announceNumbers = [String]()
    var announceTerminals = [String]()
    var announceServices = [String]()
    var serviceNames = [String]()
    var serviceIds = [String]()
    var serviceEnabled = [Bool]()
    var timerCounter: NSTimer?
    var audioPlayer = AVAudioPlayer()
    let dingSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("doorbell_x", ofType: "wav")!)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        self.broadcastNumbers.backgroundColor = UIColor.whiteColor()
        self.navigationItem.title = self.chosenBusiness?.name
//        let broadcastHeight = UIScreen.mainScreen().bounds.height / 2.0
//        var broadcastNumbersFrame = self.broadcastNumbers.frame
//        broadcastNumbersFrame.size.height = broadcastHeight
//        self.broadcastNumbers.frame = broadcastNumbersFrame
//        var serviceListFrame = self.serviceList.frame
//        serviceListFrame.size.height = UIScreen.mainScreen().bounds.height - (broadcastHeight + 32)
//        self.serviceList.frame = serviceListFrame
        
    }

    override func viewDidDisappear(animated: Bool) {
        self.timerCounter!.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.readyDingSound()
        self.timerCounter = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(FQBusinessViewController.timerCallbacks), userInfo: nil, repeats: true)
        self.getBusinessNumbers(self.chosenBusiness!.businessId!, user_id: Session.instance.user_id)
    }
    
    func timerCallbacks() {
        self.getBroadcastNumbers(self.chosenBusiness!.businessId!)
    }
    
    func readyDingSound() {
        do{
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: self.dingSound, fileTypeHint: nil)
            self.audioPlayer.prepareToPlay()
        }catch {
            print("Error getting the audio file")
        }
    }
    
    func getBusinessNumbers(business_id: String, user_id: String) {
        SwiftSpinner.show("Fetching..")
        self.serviceNames.removeAll()
        self.serviceIds.removeAll()
        self.serviceEnabled.removeAll()
        Alamofire.request(Router.getBusinessNumbers(business_id: business_id, user_id: user_id)).responseJSON { response in
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
            for serviceList in responseData["service_list"] {
                let dataObj = serviceList.1.dictionaryObject!
                self.serviceNames.append(dataObj["service_name"] as! String)
                self.serviceIds.append("\(dataObj["service_id"]!)")
                self.serviceEnabled.append(dataObj["enabled"] as! Bool)
            }
            self.serviceList.reloadData()
            SwiftSpinner.hide()
        }
    }
    
    func getBroadcastNumbers(business_id: String) {
        self.newNumbers.removeAll()
        self.announceTerminals.removeAll()
        self.announceServices.removeAll()
        let baseUrl = NSURL(string: Router.baseURL)!
        let appendUrl = NSURL(string: "/json/" + business_id + ".json?nocache=\(NSDate().timeIntervalSince1970)", relativeToURL:baseUrl)!
        let requestUrl = NSMutableURLRequest(URL: appendUrl)
        Alamofire.request(requestUrl).responseJSON { response in
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
            let numBoxes = (dataObj["display"] as! String).componentsSeparatedByString("-")
            let display = numBoxes[1]
            self.numBoxes = Int(display)!
            for count in 1...self.numBoxes {
                self.newNumbers.append(dataObj["box\(count)"]!["number"] as! String)
                self.announceTerminals.append(dataObj["box\(count)"]!["terminal"] as! String)
                self.announceServices.append(dataObj["box\(count)"]!["service"] as! String)
            }
            if self.announceNumbers != self.newNumbers {
                self.audioPlayer.play()
            }
            self.announceNumbers = self.newNumbers
            let ticker1 = (dataObj["ticker_message"] as! String) + " "
            let ticker2 = (dataObj["ticker_message2"] as! String) + " "
            let ticker3 = (dataObj["ticker_message3"] as! String) + " "
            let ticker4 = (dataObj["ticker_message4"] as! String) + " "
            let ticker5 = (dataObj["ticker_message5"] as! String) + " "
            self.tickerNotes.text = ticker1 + ticker2 + ticker3 + ticker4 + ticker5
            self.broadcastNumbers.reloadData()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "viewMyInbox" {
            let destView = segue.destinationViewController as! FQMessageViewController
            destView.business_id = self.chosenBusiness!.businessId!
            destView.business_name = self.chosenBusiness!.name!
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.numBoxes
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FQBroadcastCollectionViewCell", forIndexPath: indexPath) as! FQBroadcastCollectionViewCell
        
        // Configure the cell
        if !self.announceNumbers.isEmpty {
            cell.number.text = self.announceNumbers[indexPath.row]
            cell.terminalName.text = self.announceTerminals[indexPath.row]
            cell.serviceName.text = self.announceServices[indexPath.row]
        }
//        cell.number.text = "\(indexPath.row)"
//        cell.terminalName.text = "Counter 1"
//        cell.serviceName.text = "Berdugo"
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellWidth: CGFloat = UIScreen.mainScreen().bounds.width / 2
        //let cellHeight = self.broadcastNumbers.bounds.height / (CGFloat(self.numBoxes) / 2.0)
        let cellHeight = self.broadcastNumbers.bounds.height / 5.0
        return CGSize(width: cellWidth - 2.0, height: cellHeight - 2.0)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "SERVICES"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serviceNames.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FQRemoteQueueTableViewCell", forIndexPath: indexPath) as! FQRemoteQueueTableViewCell
        cell.rowCount.text = "\(indexPath.row + 1)"
        cell.serviceName.text = self.serviceNames[indexPath.row]
        if Session.instance.inQueue {
            cell.getNumLbl.text = "You are currently in another line."
            cell.getNumLbl.backgroundColor = UIColor.lightGrayColor()
        }
        else if !self.serviceEnabled[indexPath.row] {
            cell.getNumLbl.text = "NOT ALLOWED"
            cell.getNumLbl.backgroundColor = UIColor.lightGrayColor()
        }
        else {
            cell.getNumLbl.text = "Get a Number"
            cell.getNumLbl.backgroundColor = UIColor(red: 0.851, green: 0.4471, blue: 0.0902, alpha: 1.0) /* #d97217 */
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let alertBox = UIAlertController(title: "Confirm", message: "Do you want to line up in " + self.serviceNames[indexPath.row] + "?", preferredStyle: .Alert)
        alertBox.addAction(UIAlertAction(title: "YES", style: .Default, handler: { (action: UIAlertAction!) in
            self.getQueueService(Session.instance.user_id, service_id: self.serviceIds[indexPath.row])
        }))
        alertBox.addAction(UIAlertAction(title: "NO", style: .Default, handler: nil))
        self.presentViewController(alertBox, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if Session.instance.inQueue || !self.serviceEnabled[indexPath.row] {
            return nil
        }
        return indexPath
    }
    
    func getQueueService(user_id: String, service_id: String) {
        SwiftSpinner.show("Lining up..")
        Alamofire.request(Router.getQueueService(user_id: user_id, service_id: service_id)).responseJSON { response in
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
            Session.instance.inQueue = true
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
}
