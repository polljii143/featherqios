//
//  FQUserFormsTableViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 7/19/16.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON

class FQUserFormsTableViewController: UITableViewController {
    
    var chosenBusiness: FQBusiness?
    var serviceId: String?
    var serviceName: String?
    var formData = [[String:String]]()
    var transactionNumber: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.title = self.serviceName
    }

    override func viewWillAppear(animated: Bool) {
        self.getUserRecords(self.transactionNumber!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.formData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FQFormListTableViewCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = self.formData[indexPath.row]["form_name"]
        
        return cell
    }

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destView = segue.destinationViewController as! FQUserRecordTableViewController
        if let selectedCell = sender as? UITableViewCell {
            let indexPath = self.tableView.indexPathForCell(selectedCell)!
            destView.formName = self.formData[indexPath.row]["form_name"]
            destView.recordId = self.formData[indexPath.row]["record_id"]
        }
    }
    
    func getUserRecords(transactionNumber: String) {
        SwiftSpinner.show("Searching records..")
        self.formData.removeAll()
        Alamofire.request(Router.getUserRecords(transactionNumber: self.transactionNumber!)).responseJSON { response in
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
            for record in responseData {
                let dataObj = record.1.dictionaryObject!
                self.formData.append([
                    "record_id": "\(dataObj["record_id"]!)",
                    "form_name": dataObj["form_name"] as! String
                ])
            }
            self.tableView.reloadData()
            SwiftSpinner.hide()
        }
    }

}
