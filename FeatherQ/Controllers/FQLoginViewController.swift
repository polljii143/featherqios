//
//  FQLoginViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 01/02/2016.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON
import SwiftSpinner
import Alamofire

class FQLoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if FBSDKAccessToken.currentAccessToken() == nil
        {
            let loginView: FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.center.y = UIScreen.mainScreen().bounds.height - 100
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        SwiftSpinner.show("Verifying..")
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"id, first_name, last_name, email, gender"]).startWithCompletionHandler { (connection, result, error) -> Void in
            if result != nil {
                let fbFirstName = (result.objectForKey("first_name") as? String)!
                let fbLastName: String = (result.objectForKey("last_name") as? String)!
                let fbEmail: String = (result.objectForKey("email") as? String)!
                let fbId: String = (result.objectForKey("id") as? String)!
                let fbGender: String = (result.objectForKey("gender") as? String)!
                
                Alamofire.request(Router.postRegisterUser(fbId: fbId, firstName: fbFirstName, lastName: fbLastName, email: fbEmail, gender: fbGender)).responseJSON { response in
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
                    
                    Alamofire.request(Router.postFacebookLogin(fbId: fbId)).responseJSON { response in
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
                        Session.instance.fbId = fbId
                        Session.instance.firstName = fbFirstName
                        Session.instance.lastName = fbLastName
                        Session.instance.email = fbEmail
                        Session.instance.gender = fbGender
                        Session.instance.address = dataObj["local_address"] as! String
                        Session.instance.phone = dataObj["phone"] as! String
                        Session.instance.userId = "\(dataObj["user_id"]!)"
                        SwiftSpinner.hide({
                            self.view.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FQTabBarViewController")
                        })
                    }
                }
            }
            else {
                SwiftSpinner.show("Oops! You need to authorize your Facebook account to use the app.", animated: false).addTapHandler({
                    SwiftSpinner.hide()
                })
            }
            return
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        debugPrint("User Logged Out")
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
