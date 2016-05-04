//
//  FQPrototypeLoaderViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 4/24/16.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit
import SwiftSpinner

class FQPrototypeLoaderViewController: UIViewController {
    
    var timerCounter: NSTimer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.timerCounter = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(FQPrototypeLoaderViewController.timerCallbacks), userInfo: nil, repeats: true)
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
    
    func timerCallbacks() {
        self.timerCounter?.invalidate()
        self.view.window?.rootViewController = UIStoryboard(name: "Prototype", bundle: nil).instantiateViewControllerWithIdentifier("FQTabBarViewController")
    }

}
