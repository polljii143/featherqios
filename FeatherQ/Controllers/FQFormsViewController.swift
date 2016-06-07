//
//  FQFormsViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 5/23/16.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class FQFormsViewController: UIViewController {
    
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var availableNumber: UILabel!
    @IBOutlet weak var timeUntilCalled: UILabel!
    @IBOutlet weak var peopleInLine: UILabel!
    
    var businessId = ""
    var serviceId = ""
    var businessName = ""
    var serviceNameText = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = self.businessName
        self.serviceName.text = self.serviceNameText
        self.getFormElements(self.businessId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFormElements(businessId: String) {
        SwiftSpinner.show("Rendering form..")
        Alamofire.request(Router.getFormElements(businessId: businessId)).responseJSON { response in
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
            debugPrint(dataObj)
            SwiftSpinner.hide();
        }
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
