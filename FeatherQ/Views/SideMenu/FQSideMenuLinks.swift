//
//  FQSideMenuLinks.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 01/02/2016.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit

class FQSideMenuLinks: UIView {

    var icon: String?
    var title: String?
    
    init(linkIcon: String, linkTitle: String) {
        self.icon = linkIcon
        self.title = linkTitle
        super.init(frame: CGRect(x: 0, y: 0, width: 250, height: 44))
        self.displayIcon()
        self.displayTitle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func displayIcon() {
        let icon = UIImage(named: self.icon!)
        let iconView = UIImageView(image: icon)
        iconView.frame = CGRectMake(20.0, 7.0, 32.0, 32.0)
        addSubview(iconView)
    }
    
    private func displayTitle() {
        let titleLabel = UILabel(frame: CGRect(x: 75, y: 0, width: 200, height: 44))
        titleLabel.text = self.title
        //titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(15.0)
        addSubview(titleLabel)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
