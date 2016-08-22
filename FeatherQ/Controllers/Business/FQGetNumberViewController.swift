//
//  FQGetNumberViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 7/8/16.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class FQGetNumberViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var chosenBusiness: FQBusiness?
    var serviceId: String?
    var serviceName: String?
    var formData = [[String:String]]()
    var timerCounter: NSTimer?
    var transactionNumber: String?

    @IBOutlet weak var serviceNameLbl: UILabel!
    @IBOutlet weak var formList: UITableView!
    @IBOutlet weak var availableNumber: UILabel!
    @IBOutlet weak var estimatedCallTime: UILabel!
    @IBOutlet weak var peopleInLine: UILabel!
    @IBOutlet weak var getNumBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = self.chosenBusiness?.name
        self.serviceNameLbl.text = self.serviceName
        self.getNumBtn.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(animated: Bool) {
        SwiftSpinner.show("Getting estimates..")
        self.getServiceEstimates(self.serviceId!, closure: {
            self.getDisplayForms(self.serviceId!)
        })
        self.timerCounter = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(FQGetNumberViewController.timerCallbacks), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.timerCounter!.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.formData.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "FORMS"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FQFormListTableViewCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = self.formData[indexPath.row]["formName"]
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "formFillup" {
            let selectedCell = sender as? UITableViewCell
            let indexPath = self.formList.indexPathForCell(selectedCell!)!
            let destView = segue.destinationViewController as! FQFormTableViewController
            destView.formName = self.formData[indexPath.row]["formName"]
            destView.formId = self.formData[indexPath.row]["formId"]
            destView.formIndex = indexPath.row
        }
    }
    
    @IBAction func getNumber(sender: AnyObject) {
        debugPrint(Session.instance.serviceFormData)
        if Session.instance.serviceFormData.count < self.formData.count {
            let alertBox = UIAlertController(title: "NOT ALLOWED", message: "You must fill up the forms before getting the number.", preferredStyle: .Alert)
            alertBox.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertBox, animated: true, completion: nil)
        }
        else {
            let alertBox = UIAlertController(title: "Confirm", message: "Do you want to line up in this service?", preferredStyle: .Alert)
            alertBox.addAction(UIAlertAction(title: "YES", style: .Default, handler: { (action: UIAlertAction!) in
                self.getQueueService(Session.instance.user_id, service_id: self.serviceId!, closure: {
                  self.postSubmitForm(Session.instance.user_id, transactionNumber: self.transactionNumber!, formSubmissions: Session.instance.serviceFormData, serviceId: self.serviceId!, serviceName: self.serviceName!)
                })
            }))
            alertBox.addAction(UIAlertAction(title: "NO", style: .Default, handler: nil))
            self.presentViewController(alertBox, animated: true, completion: nil)
        }
    }
    
    func postSubmitForm(userId: String, transactionNumber: String, formSubmissions: [[String:[[String:String]]]], serviceId: String, serviceName: String) {
        SwiftSpinner.show("Submitting form..")
        Alamofire.request(Router.postSubmitForm(userId: userId, transactionNumber: transactionNumber, formSubmissions: formSubmissions, serviceId: serviceId, serviceName: serviceName)).responseJSON { response in
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
            self.performSegueWithIdentifier("afterGetNum", sender: self)
        }
    }
    
    func getQueueService(user_id: String, service_id: String, closure: () -> Void) {
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
            self.transactionNumber = responseData["transaction_number"].stringValue
            Session.instance.inQueue = true
            closure()
        }
    }
    
    func getServiceEstimates(serviceId: String, closure: () -> Void) {
        Alamofire.request(Router.getServiceEstimates(serviceId: serviceId)).responseJSON { response in
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
            self.availableNumber.text = "\(dataObj["next_number"]!)"
            let upperLimit = dataObj["upper_limit"] as! String
            let lowerLimit = dataObj["lower_limit"] as! String
            self.estimatedCallTime.text = lowerLimit + " ~ " + upperLimit
            self.peopleInLine.text = "\(dataObj["numbers_ahead"]!)"
            closure()
        }
    }
    
    func getDisplayForms(serviceId: String) {
        SwiftSpinner.show("Loading forms..")
        self.formData.removeAll()
        Alamofire.request(Router.getDisplayForms(serviceId: serviceId)).responseJSON { response in
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
            for formList in responseData["forms"] {
                let dataObj = formList.1.dictionaryObject!
                self.formData.append([
                    "formName" : dataObj["form_name"] as! String,
                    "formId": "\(dataObj["form_id"]!)"
                ])
            }
            self.formList.reloadData()
            SwiftSpinner.hide()
        }
    }
    
    func timerCallbacks() {
        self.getServiceEstimates(self.serviceId!, closure: {})
    }

}
