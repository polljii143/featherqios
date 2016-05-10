//
//  FQQRCodeScannerViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 5/6/16.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit
import SwiftQRCode
import Alamofire
import SwiftyJSON
import SwiftSpinner

class FQQRCodeScannerViewController: UIViewController {
    
    let scanner = QRCode()
    var scannedBusiness: FQBusiness?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scanner.prepareScan(view) { (stringValue) -> () in
            debugPrint(stringValue)
            let businessUrl = stringValue.componentsSeparatedByString("/") // "http://new-featherq.local/broadcast/business/181"
            let business_id = businessUrl[5];
            self.getBusinessDetail(business_id)
        }
        scanner.scanFrame = view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        scanner.startScan()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destView = segue.destinationViewController as! FQBusinessViewController
        destView.chosenBusiness = self.scannedBusiness!
    }
    
    func getBusinessDetail(business_id: String) {
        SwiftSpinner.show("Locating business..")
        Alamofire.request(Router.getBusinessDetail(id: business_id)).responseJSON { response in
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
            self.scannedBusiness = FQBusiness(modelAttr: [
                "business_id": "\(dataObj["business_id"]!)",
                "name": dataObj["name"] as! String,
                "local_address": dataObj["local_address"] as! String,
                "longitude": "\(dataObj["longitude"]!)",
                "latitude": "\(dataObj["latitude"]!)",
                "distance": 0,
            ])
            SwiftSpinner.hide();
            self.performSegueWithIdentifier("qrScannedBusiness", sender: self)
        }
    }

}
