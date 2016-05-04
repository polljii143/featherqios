//
//  FQCategoriesViewController.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 25/01/2016.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit

class FQCategoriesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    let categories = ["ALL", "ACCOUNTING", "AGRICULTURE", "AIR SERVICES", "AUTO DEALERSHIP", "BUSINESS SERVICES", "COMMUNICATIONS", "CUSTOMER SERVICE", "EDUCATION", "ENTERTAINMENT", "FOOD AND BEVERAGE", "GOVERNMENT", "GROCERY", "HEALTHCARE", "PHARMACEUTICAL", "REAL ESTATE", "RETAIL", "TECHNOLOGY", "UTILITY SERVICES"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.categoryCollection.backgroundColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 19
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FQCategoriesCollectionViewCell", forIndexPath: indexPath) as! FQCategoriesCollectionViewCell
        
        // Configure the cell
        cell.backgroundColor = UIColor.blackColor()
        cell.imgBackground.image = UIImage(named: self.categories[indexPath.row])
        cell.title.text = categories[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let squareSize = (UIScreen.mainScreen().bounds.width / 3.0) - 2.0
        return CGSize(width: squareSize, height: squareSize)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "searchIndustry" {
            let destView = segue.destinationViewController as! FQExploreViewController
            if let selectedCell = sender as? FQCategoriesCollectionViewCell {
                destView.categoryType = selectedCell.title.text!
            }
        }
    }

}
