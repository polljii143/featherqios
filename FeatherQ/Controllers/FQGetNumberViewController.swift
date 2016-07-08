//
//  FQGetNumberViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 7/8/16.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit

class FQGetNumberViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var chosenBusiness: FQBusiness?
    var serviceId: String?
    var serviceName: String?

    @IBOutlet weak var serviceNameLbl: UILabel!
    @IBOutlet weak var formList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = self.chosenBusiness?.name
        self.serviceNameLbl.text = self.serviceName
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
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FQFormListTableViewCell", forIndexPath: indexPath)
        cell.textLabel?.text = "Shipping Details"
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
