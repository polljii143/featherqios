//
//  FQFormTableViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 7/9/16.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON

class FQFormTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var pickerData = [[String]]()
    var formName: String?
    var formId: String?
    var fieldData = [[String:String]]()
    var tagsFieldType = [String]()
    var formSubmit = [[String:String]]()
    var formIndex: Int?
    
    let TAG_UNIQUE = 21 // add this num to make tags unique

    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.separatorStyle = .None
        self.navigationItem.title = self.formName!
    }
    
    override func viewWillAppear(animated: Bool) {
        self.getViewForm(self.formId!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.fieldData.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.fieldData[indexPath.row]["field_type"] == "radio" {
            return 77.0
        }
        else if self.fieldData[indexPath.row]["field_type"] == "dropdown" {
            return 130.0
        }
        else {
            return 44.0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FQFormTableViewCell", forIndexPath: indexPath)

        // Configure the cell...
        if self.fieldData[indexPath.row]["field_type"] == "radio" {
            cell.addSubview(self.renderRadioButton(self.fieldData[indexPath.row], viewTag: indexPath.row))
        }
        else if self.fieldData[indexPath.row]["field_type"] == "textfield" {
            cell.addSubview(self.renderTextField(self.fieldData[indexPath.row], viewTag: indexPath.row))
        }
        else if self.fieldData[indexPath.row]["field_type"] == "checkbox" {
            cell.addSubview(self.renderCheckbox(self.fieldData[indexPath.row], viewTag: indexPath.row))
        }
        else if self.fieldData[indexPath.row]["field_type"] == "dropdown" {
            cell.addSubview(self.renderDropdown(self.fieldData[indexPath.row], viewTag: indexPath.row))
        }

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
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[component][row]
    }

    // MARK: - Navigation

//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        let destView = segue.destinationViewController as! FQGetNumberViewController
//        destView.serviceFormsSubmit.append(self.serviceForm)
//        destView.serviceId = self.persistServiceId!
//        debugPrint(self.serviceForm)
//    }

    @IBAction func saveForm(sender: AnyObject) {
        self.formSubmit.removeAll()
        for i in 0 ..< self.tagsFieldType.count {
            self.formSubmit.append([
                "xml_tag": self.fieldData[i]["label"]!.stringByReplacingOccurrencesOfString(" ", withString: "").lowercaseString,
                "xml_val": self.getFormFieldValues(i)
            ])
        }
        self.appendOrReplaceFormData(self.formIndex!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func appendOrReplaceFormData(index: Int) {
        let arrVal = [self.formId! : self.formSubmit]
        if Session.instance.serviceFormData.indices.contains(index) {
            Session.instance.serviceFormData[index] = arrVal
        }
        else {
            Session.instance.serviceFormData.append(arrVal)
        }
    }
    
    func getFormFieldValues(i: Int) -> String {
        if self.tagsFieldType[i] == "textfield" {
            let textField = self.view.viewWithTag(i + TAG_UNIQUE) as! UITextField
            return textField.text!
        }
        else if self.tagsFieldType[i] == "radio" {
            let radio = self.view.viewWithTag(i + TAG_UNIQUE) as! UISegmentedControl
            return radio.titleForSegmentAtIndex(radio.selectedSegmentIndex)!
        }
        else if self.tagsFieldType[i] == "checkbox" {
            let checkbox = self.view.viewWithTag(i + TAG_UNIQUE) as! UISwitch
            if checkbox.on {
                return "\(1)"
            }
            return "\(0)"
        }
        let dropdown = self.view.viewWithTag(i + TAG_UNIQUE) as! UIPickerView
        return self.pickerData[0][dropdown.selectedRowInComponent(0)]
    }
    
    func getViewForm(formId: String) {
        SwiftSpinner.show("Rendering form..")
        self.pickerData.removeAll()
        self.fieldData.removeAll()
        Alamofire.request(Router.getViewForm(form_id: formId)).responseJSON { response in
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
            for formFields in responseData["fields"] {
                let dataObj = formFields.1.dictionaryObject!
                let fieldDataArr = self.fieldTypeIndexChecker(dataObj)
                self.fieldData.append([
                    "field_type" : dataObj["field_type"] as! String,
                    "label": dataObj["field_data"]!["label"] as! String,
                    "value_a": fieldDataArr["value_a"]!,
                    "value_b": fieldDataArr["value_b"]!
                ])
            }
            debugPrint(self.fieldData)
            self.tableView.reloadData()
            SwiftSpinner.hide()
        }
    }
    
    func fieldTypeIndexChecker(dataObj: [String:AnyObject]) -> [String:String] {
        var arr = [String:String]()
        let fieldType = dataObj["field_type"] as! String
        if fieldType == "radio" {
            arr["value_a"] = dataObj["field_data"]!["value_a"] as? String
            arr["value_b"] = dataObj["field_data"]!["value_b"] as? String
        }
        else if fieldType == "dropdown" {
            let options = dataObj["field_data"]!["options"] as! [String:AnyObject]
            let optionArray = Array(options.keys)
            self.pickerData.append(optionArray)
            arr["value_a"] = ""
            arr["value_b"] = ""
        }
        else {
            arr["value_a"] = ""
            arr["value_b"] = ""
        }
        return arr
    }
    
    func renderRadioButton(fieldData: [String:String], viewTag: Int) -> UIView {
        let viewWrapper = UIView(frame: CGRect(x: 8.0, y: 4.0, width: UIScreen.mainScreen().bounds.width - 30.0, height: self.view.bounds.height))
        let radioLbl = UILabel(frame: CGRect(x: 8.0, y: 4.0, width: viewWrapper.bounds.width, height: 21.0))
        radioLbl.text = fieldData["label"]
        radioLbl.textColor = UIColor.darkGrayColor()
        radioLbl.font = UIFont.systemFontOfSize(17.0)
        let radioBtn = UISegmentedControl(frame: CGRect(x: 8.0, y: 33.0, width: viewWrapper.bounds.width, height: 29.0))
        radioBtn.insertSegmentWithTitle(fieldData["value_a"], atIndex: 0, animated: false)
        radioBtn.insertSegmentWithTitle(fieldData["value_b"], atIndex: 1, animated: false)
        radioBtn.tag = viewTag + TAG_UNIQUE
        radioBtn.selectedSegmentIndex = 0
        self.tagsFieldType.append("radio")
        viewWrapper.addSubview(radioLbl)
        viewWrapper.addSubview(radioBtn)
        return viewWrapper
    }
    
    func renderTextField(fieldData: [String:String], viewTag: Int) -> UIView {
        let viewWrapper = UIView(frame: CGRect(x: 8.0, y: 4.0, width: UIScreen.mainScreen().bounds.width - 30.0, height: self.view.bounds.height))
        let textField = UITextField(frame: CGRect(x: 8.0, y: 4.0, width: viewWrapper.bounds.width, height: 30.0))
        textField.placeholder = fieldData["label"]
        textField.font = UIFont.systemFontOfSize(17.0)
        textField.tag = viewTag + TAG_UNIQUE
        self.tagsFieldType.append("textfield")
        viewWrapper.addSubview(textField)
        return viewWrapper
    }
    
    func renderCheckbox(fieldData: [String:String], viewTag: Int) -> UIView {
        let viewWrapper = UIView(frame: CGRect(x: 8.0, y: 4.0, width: UIScreen.mainScreen().bounds.width - 30.0, height: self.view.bounds.height))
        let checkLbl = UILabel(frame: CGRect(x: 8.0, y: 7.0, width: viewWrapper.bounds.width - 55.0, height: 21.0))
        checkLbl.text = fieldData["label"]
        checkLbl.textColor = UIColor.darkGrayColor()
        checkLbl.font = UIFont.systemFontOfSize(17.0)
        let checkBox = UISwitch(frame: CGRect(x: viewWrapper.bounds.width - 51.0, y: 3.0, width: 51.0, height: 31.0))
        checkBox.tag = viewTag + TAG_UNIQUE
        self.tagsFieldType.append("checkbox")
        viewWrapper.addSubview(checkLbl)
        viewWrapper.addSubview(checkBox)
        return viewWrapper
    }
    
    func renderDropdown(fieldData: [String:String], viewTag: Int) -> UIView {
        let viewWrapper = UIView(frame: CGRect(x: 8.0, y: 4.0, width: UIScreen.mainScreen().bounds.width - 30.0, height: self.view.bounds.height))
        let dropdownLbl = UILabel(frame: CGRect(x: 8.0, y: 4.0, width: viewWrapper.bounds.width, height: 21.0))
        dropdownLbl.text = fieldData["label"]
        dropdownLbl.font = UIFont.systemFontOfSize(17.0)
        dropdownLbl.textColor = UIColor.darkGrayColor()
        let dropdownPicker = UIPickerView(frame: CGRect(x: 8.0, y: 25.0, width: viewWrapper.bounds.width, height: 100.0))
        dropdownPicker.delegate = self
        dropdownPicker.dataSource = self
        dropdownPicker.tag = viewTag + TAG_UNIQUE
        self.tagsFieldType.append("dropdown")
        viewWrapper.addSubview(dropdownLbl)
        viewWrapper.addSubview(dropdownPicker)
        return viewWrapper
    }
    
}
