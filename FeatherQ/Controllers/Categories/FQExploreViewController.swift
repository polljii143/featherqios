//
//  FQExploreViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 25/01/2016.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON

class FQExploreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    
    var exploreBusiness = [FQBusiness]()
    var filteredBusinesses = [String]()
    var filterSearch = UISearchController()
    var categoryType = "ALL"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.categorySearch(self.categoryType)
        self.filterSearch = UISearchController(searchResultsController: nil)
        self.filterSearch.searchResultsUpdater = self
        self.filterSearch.dimsBackgroundDuringPresentation = false
        self.filterSearch.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.filterSearch.searchBar
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func categorySearch(categoryType: String) {
        if categoryType == "ALL" {
            self.getActiveBusinesses()
        }
        else {
            self.getSearchIndustry(categoryType)
        }
    }
    
    func getSearchIndustry(categoryType: String) {
        SwiftSpinner.show("Fetching...");
        Alamofire.request(Router.getSearchIndustry(query: categoryType)).responseJSON { response in
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
                self.exploreBusiness.append(FQBusiness(modelAttr: businessData.1.dictionaryObject!))
            }
            self.tableView.reloadData()
            SwiftSpinner.hide()
        }
    }
    
    func getActiveBusinesses() {
        SwiftSpinner.show("Fetching...");
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
            debugPrint(responseData)
            for businessData in responseData["search-result"] {
                self.exploreBusiness.append(FQBusiness(modelAttr: businessData.1.dictionaryObject!))
            }
            self.tableView.reloadData()
            SwiftSpinner.hide()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.filterSearch.active {
            return self.filteredBusinesses.count
        }
        else {
            return exploreBusiness.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("businessList") as! FQExploreTableViewCell
        
        if self.filterSearch.active {
            let businessData = self.filteredBusinesses[indexPath.row].componentsSeparatedByString("|")
            cell.businessName.text = businessData[0]
            cell.address.text = businessData[1]
            cell.distance.text = businessData[2] + " km"
        }
        else {
            cell.businessName.text = self.exploreBusiness[indexPath.row].name
            cell.address.text = self.exploreBusiness[indexPath.row].localAddress
            cell.distance.text = self.exploreBusiness[indexPath.row].distance! + " km"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120.0
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        var unwrappedBusinessNames = [String]()
        for business in self.exploreBusiness {
            unwrappedBusinessNames.append(business.name!+"|"+business.localAddress!+"|"+business.distance!+"|"+business.businessId!)
        }
        self.filteredBusinesses.removeAll(keepCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (unwrappedBusinessNames as NSArray).filteredArrayUsingPredicate(searchPredicate)
        self.filteredBusinesses = array as! [String]
        self.tableView.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "broadcastPage" {
            SwiftSpinner.show("Viewing..");
            let destView = segue.destinationViewController as! FQBusinessViewController
            if let selectedCell = sender as? FQExploreTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedCell)!
                if self.filterSearch.active {
                    let businessData = self.filteredBusinesses[indexPath.row].componentsSeparatedByString("|")
                    destView.chosenBusiness = FQBusiness(modelAttr: [
                        "business_id": businessData[3],
                        "name": businessData[0],
                        "local_address": businessData[1],
                        "longitude": "",
                        "latitude": "",
                        "distance": businessData[2].stringByReplacingOccurrencesOfString(",", withString: ""),
                    ])
                    self.filterSearch.active = false
                }
                else {
                    destView.chosenBusiness = self.exploreBusiness[indexPath.row]
                }
            }
        }
    }
}
