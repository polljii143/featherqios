//
//  FQUserRecordTableViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 7/20/16.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class FQUserRecordTableViewController: UITableViewController {
    
    var formName: String?
    var recordId: String?
    var formLabels = [String]()
    var formFieldData = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.title = self.formName!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.getViewRecord(self.recordId!)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.formLabels.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FQUserRecordTableViewCell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.formFieldData[indexPath.row]
        cell.detailTextLabel?.text = self.formLabels[indexPath.row]

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getViewRecord(recordId: String) {
        SwiftSpinner.show("Loading info..")
        Alamofire.request(Router.getViewRecord(recordId: recordId)).responseJSON { response in
            if response.result.isFailure {
                debugPrint(response.result.error)
                let errorMessage = (response.result.error?.localizedDescription)! as String
                SwiftSpinner.show(errorMessage, animated: false).addTapHandler({
                    SwiftSpinner.hide()
                })
                return
            }
            let responseData = JSON(data: response.data!)
            for formFields in responseData["fields"] {
                let dataObj = formFields.1.dictionaryObject!
                let fieldName = dataObj["field_data"]!["label"] as! String
                self.formLabels.append(fieldName)
            }
            for labelVal in self.formLabels {
                let labelKey = labelVal.stringByReplacingOccurrencesOfString(" ", withString: "").lowercaseString
                let fieldVal = responseData["form_data"]["form_data"][labelKey].stringValue
                self.formFieldData.append(fieldVal)
            }
            self.tableView.reloadData()
            SwiftSpinner.hide()
        }
    }

}
