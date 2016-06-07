//
//  FQRemoteViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 4/21/16.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit
import SwiftSpinner
import SwiftyJSON
import Alamofire
import AVFoundation
import MarqueeLabel

class FQRemoteViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var broadcastNumbers: UICollectionView!
    @IBOutlet weak var priorityNumber: UILabel!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var timeLeft: UILabel!
    @IBOutlet weak var peopleAhead: UILabel!
    @IBOutlet weak var checkInLbl: UILabel!
    @IBOutlet weak var checkInBtn: UIBarButtonItem!
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
    var transactionNumber = ""
    let dingSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("doorbell_x", ofType: "wav")!)
    @IBOutlet weak var checkInStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view
        self.broadcastNumbers.backgroundColor = UIColor.whiteColor()
        self.navigationItem.title = self.chosenBusiness?.name
        //let broadcastHeight = UIScreen.mainScreen().bounds.height / 2.0
        //var broadcastNumbersFrame = self.broadcastNumbers.frame
        //broadcastNumbersFrame.size.height = broadcastHeight
        //self.broadcastNumbers.frame = broadcastNumbersFrame
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.timerCounter!.invalidate()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.readyDingSound()
        self.timerCounter = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(FQRemoteViewController.timerCallbacks), userInfo: nil, repeats: true)
        self.getBusinessBroadcast(self.chosenBusiness!.businessId!, userId: Session.instance.userId)
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
            destView.businessId = self.chosenBusiness!.businessId!
            destView.businessName = self.chosenBusiness!.name!
            destView.queuedBusiness = self.chosenBusiness!.businessId!
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
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellWidth: CGFloat = UIScreen.mainScreen().bounds.width / 2
        //let cellHeight = self.broadcastNumbers.bounds.height / (CGFloat(self.numBoxes) / 2.0)
        let cellHeight = self.broadcastNumbers.bounds.height / 5.0
        return CGSize(width: cellWidth - 2.0, height: cellHeight - 2.0)
    }
    
    @IBAction func checkInUser(sender: AnyObject) {
        let alertBox = UIAlertController(title: "Confirm", message: "Do you want to check-in now?", preferredStyle: .Alert)
        alertBox.addAction(UIAlertAction(title: "YES", style: .Default, handler: { (action: UIAlertAction!) in
            self.getCheckinTransaction(self.transactionNumber)
        }))
        alertBox.addAction(UIAlertAction(title: "NO", style: .Default, handler: nil))
        self.presentViewController(alertBox, animated: true, completion: nil)
    }
    
    func getQueueService(userId: String, serviceId: String) {
        SwiftSpinner.show("Lining up..")
        Alamofire.request(Router.getQueueService(userId: userId, serviceId: serviceId)).responseJSON { response in
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
            SwiftSpinner.hide();
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
                self.checkInStatus.text = "CHECKED IN"
                self.checkInStatus.backgroundColor = UIColor(red: 0, green: 0.4275, blue: 0.2627, alpha: 1.0) /* #006d43 */
                self.checkInBtn.enabled = false
            }
            else {
                self.checkInStatus.text = "NOT CHECKED IN"
                self.checkInStatus.backgroundColor = UIColor(red: 0.7176, green: 0, blue: 0, alpha: 1.0) /* #b70000 */
                self.checkInBtn.enabled = true
            }
            SwiftSpinner.hide()
        }
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
    
    func getBroadcastNumbers(businessId: String) {
        self.newNumbers.removeAll()
        self.announceTerminals.removeAll()
        self.announceServices.removeAll()
        let baseUrl = NSURL(string: Router.baseURL)!
        let appendUrl = NSURL(string: "/json/" + businessId + ".json?nocache=\(NSDate().timeIntervalSince1970)", relativeToURL:baseUrl)!
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
            self.broadcastNumbers.reloadData()
        }
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
            self.checkInBtn.enabled = false
            self.checkInStatus.text = "CHECKED IN"
            self.checkInStatus.backgroundColor = UIColor(red: 0, green: 0.4275, blue: 0.2627, alpha: 1.0) /* #006d43 */
            SwiftSpinner.hide()
        }
    }
    
    func getBusinessBroadcast(businessId: String, userId: String) {
        SwiftSpinner.show("Fetching..")
        Alamofire.request(Router.getBusinessBroadcast(businessId: businessId, userId: userId)).responseJSON { response in
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
            self.priorityNumber.text = dataObj["user_priority_number"] as? String
            self.serviceName.text = dataObj["service_name"] as? String
            self.peopleAhead.text = "\(dataObj["number_people_ahead"]!)"
            self.timeLeft.text = "\(dataObj["estimated_time_left"]!)"
            let ticker1 = (dataObj["ticker_message"] as! String) + " "
            let ticker2 = (dataObj["ticker_message2"] as! String) + " "
            let ticker3 = (dataObj["ticker_message3"] as! String) + " "
            let ticker4 = (dataObj["ticker_message4"] as! String) + " "
            let ticker5 = (dataObj["ticker_message5"] as! String) + " "
            self.tickerNotes.text = ticker1 + ticker2 + ticker3 + ticker4 + ticker5
            self.getCheckedIn(self.transactionNumber)
        }
    }

}
