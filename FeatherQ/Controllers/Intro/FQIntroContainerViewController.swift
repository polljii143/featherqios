//
//  FQIntroContainerViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 22/01/2016.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit

class FQIntroContainerViewController: UIViewController, UIPageViewControllerDataSource {
    
    // TAKEN & MODIFIED FROM:
    // https://www.youtube.com/watch?v=8bltsDG2ENQ
    // http://www.appcoda.com/uipageviewcontroller-storyboard-tutorial/
    // http://stackoverflow.com/questions/21045630/how-to-put-the-uipagecontrol-element-on-top-of-the-sliding-pages-within-a-uipage
    //
    
    var pageViewController: UIPageViewController!
    var pageTitles: NSArray!
    var pageImages: NSArray!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var swipeIndex: UILabel!
    @IBOutlet weak var logoTitle: UIView!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var subDesc: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.subTitle.text = "Join A Line Virtually"
        self.subDesc.text = "Line up for a business through your\nmobile device."
        self.swipeIndex.text = "(1/3)\nswipe to continue"
        self.pageTitles = NSArray(objects: "Intro1", "Intro3", "Intro2")
        self.pageImages = NSArray(objects: "Intro1", "Intro3", "Intro2")
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("IntroPageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        let startVC = self.viewControllerAtIndex(0) as FQIntroContentViewController
        let viewControllers = NSArray(object: startVC)
        self.pageViewController.setViewControllers(viewControllers as! [FQIntroContentViewController], direction: .Forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.size.height + 40)
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        self.view.bringSubviewToFront(self.logoTitle)
        self.view.bringSubviewToFront(self.swipeIndex)
        self.view.bringSubviewToFront(self.subTitle)
        self.view.bringSubviewToFront(self.subDesc)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewControllerAtIndex(index: Int) -> FQIntroContentViewController {
        let vc: FQIntroContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FQIntroContentViewController") as! FQIntroContentViewController
        vc.imageFile = self.pageImages[index] as! String
        vc.pageIndex = index
        return vc
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! FQIntroContentViewController
        var index = vc.pageIndex as Int
        self.continueBtn.hidden = true
        if index == 0 {
            self.subTitle.text = "Join A Line Virtually"
            self.subDesc.text = "Line up for a business through your\nmobile device."
            self.swipeIndex.text = "(1/3)\nswipe to continue"
        }
        else if index == 1 {
            self.subTitle.text = "Get Updated on\nYour Mobile Device"
            self.subDesc.text = ""
            self.swipeIndex.text = "(2/3)\nswipe to continue"
        }
        if (index == 0 || index == NSNotFound) {
            return nil
        }
        index -= 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! FQIntroContentViewController
        var index = vc.pageIndex as Int
        if index == 1 {
            self.subTitle.text = "Get Updated on\nYour Mobile Device"
            self.subDesc.text = ""
            self.swipeIndex.text = "(2/3)\nswipe to continue"
        }
        else if index == 2 {
            self.continueBtn.hidden = false
            self.view.bringSubviewToFront(self.continueBtn)
            self.subTitle.text = "Do What Matters To You"
            self.subDesc.text = "You don't have to waste your time\nwhile stuck in line."
            self.swipeIndex.text = "(3/3)"
        }
        index += 1
        if (index == NSNotFound || index == self.pageTitles.count)
        {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    // END OF COPIED CODE

}
