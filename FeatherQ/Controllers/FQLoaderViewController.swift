//
//  FQLoaderViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 3/27/16.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class FQLoaderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"id, first_name, last_name, email, gender"]).startWithCompletionHandler { (connection, result, error) -> Void in
            let fbFirstName = (result.objectForKey("first_name") as? String)!
            let fbLastName: String = (result.objectForKey("last_name") as? String)!
            let fbEmail: String = (result.objectForKey("email") as? String)!
            let fbId: String = (result.objectForKey("id") as? String)!
            let fbGender: String = (result.objectForKey("gender") as? String)!
            
            Alamofire.request(Router.postFacebookLogin(fb_id: fbId)).responseJSON { response in
                if response.result.isFailure {
                    debugPrint(response.result.error)
                    let errorMessage = (response.result.error?.localizedDescription)! as String
                    SwiftSpinner.show(errorMessage, animated: false).addTapHandler({
                        SwiftSpinner.hide()
                    })
                    return
                }
                let responseData = JSON(data: response.data!)
                let dataObj = responseData["user"].dictionaryObject!
                Session.instance.fb_id = fbId
                Session.instance.firstName = fbFirstName
                Session.instance.lastName = fbLastName
                Session.instance.email = fbEmail
                Session.instance.gender = fbGender
                Session.instance.address = dataObj["local_address"] as! String
                Session.instance.phone = dataObj["phone"] as! String
                Session.instance.user_id = "\(dataObj["user_id"]!)"
                self.view.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FQTabBarViewController")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
