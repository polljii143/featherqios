//
//  FQIntroContentViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 22/01/2016.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit

class FQIntroContentViewController: UIViewController {

    // TAKEN & MODIFIED FROM:
    // https://www.youtube.com/watch?v=8bltsDG2ENQ
    //
    
    @IBOutlet weak var imageView: UIImageView!
    var imageFile: String!
    var pageIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.imageView.image = UIImage(named: self.imageFile)
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
