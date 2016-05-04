//
//  FQTestViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 21/01/2016.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Locksmith

class FQTestViewController: UIViewController {

    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = NSURL (string: "http://new-featherq.local/ha6g");
        let requestObj = NSURLRequest(URL: url!);
        self.webView.allowsInlineMediaPlayback = true
        self.webView.mediaPlaybackAllowsAirPlay = true
        self.webView.mediaPlaybackRequiresUserAction = false
        self.webView.loadRequest(requestObj);
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
    
    @IBAction func getUserInfo(sender: AnyObject) {
        
    }
    
    private func showAlertBox(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
