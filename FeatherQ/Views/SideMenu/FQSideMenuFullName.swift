//
//  FQSideMenuFullName.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 01/02/2016.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit

class FQSideMenuFullName: UIView {
    
    var firstName: String?
    
    init(firstName: String) {
        self.firstName = firstName
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 80))
        self.displayBackground()
        self.displayFullName()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func displayBackground() {
        let backgroundIcon = UIImage(named: "LoaderUpper")
        let backgroundView = UIImageView(image: backgroundIcon)
        backgroundView.frame = CGRectMake(0, 0, self.bounds.width, 100)
        addSubview(backgroundView)
    }
    
    func displayFullName() {
        let fullname = UILabel(frame: CGRect(x: 20, y: 55, width: self.bounds.width, height: 40))
        fullname.text = "Hi, " + firstName!
        fullname.textColor = UIColor.whiteColor()
        fullname.font = UIFont.systemFontOfSize(22.0)
        addSubview(fullname)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
