//
//  FQModalViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 8/25/16.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit

class FQModalViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var okGotIt: UIButton!
    @IBOutlet weak var priorityNumber: UILabel!
    @IBOutlet weak var queueService: UILabel!
    @IBOutlet weak var terminalName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
//        view.backgroundColor = UIColor.clearColor()
//        view.opaque = false
        self.containerView.layer.cornerRadius = 10.0
        self.containerView.clipsToBounds = true
        self.okGotIt.layer.cornerRadius = 10.0
    }
    
    override func viewWillAppear(animated: Bool) {
        self.priorityNumber.text = Session.instance.priorityNumber
        self.queueService.text = Session.instance.queueService
        self.terminalName.text = Session.instance.callingTerminal
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

    @IBAction func okGotIt(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
