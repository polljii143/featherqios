//
//  FQHomeCalledNumber.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 9/2/16.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import Foundation
import UIKit

class FQHomeCalledNumber: UIView {
    
    var priorityNumber: String?
    var serviceName: String?
    var terminalName: String?
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    init(priorityNumber: String, serviceName: String, terminalName: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 50.0))
        self.backgroundColor = UIColor(red: 0.851, green: 0.4471, blue: 0.0902, alpha: 1.0) /* #d97217 */
        
        self.priorityNumber = priorityNumber
        self.serviceName = serviceName
        self.terminalName = terminalName
        self.displayFqLogo()
        self.displayNotif()
        //self.displayPriorityNumber()
        //self.displayQueueService()
        //self.displayTerminal()
    }
    
    func displayFqLogo() {
        let fqIcon = UIImage(named: "LoaderUpper")
        let fqImage = UIImageView(image: fqIcon)
        fqImage.frame = CGRectMake(0.0, 0.0, self.bounds.width, self.bounds.height)
        self.addSubview(fqImage)
    }
    
    func displayNotif() {
        let notifLbl = UILabel(frame: CGRect(x: 0, y: 16.0/*36.0*/, width: self.bounds.width, height: 19.0))
        notifLbl.text = "Your number has been called!"
        notifLbl.textAlignment = .Center
        notifLbl.textColor = UIColor.whiteColor() //UIColor(red: 0, green: 0.5608, blue: 0.0824, alpha: 1.0) /* #008f15 */
        notifLbl.font = UIFont.boldSystemFontOfSize(21.0)
        self.addSubview(notifLbl)
    }
    
    func displayPriorityNumber() {
        let priorityNum = UILabel(frame: CGRect(x: 0, y: 73.0, width: self.bounds.width, height: 34.0))
        priorityNum.text = self.priorityNumber!
        priorityNum.textAlignment = .Center
        priorityNum.textColor = UIColor(red: 0.051, green: 0.6, blue: 0.9882, alpha: 1.0) /* #0d99fc */
        priorityNum.font = UIFont.boldSystemFontOfSize(41.0)
        self.addSubview(priorityNum)
    }
    
    func displayTerminal() {
        let terminalLbl = UILabel(frame: CGRect(x: 0, y: 115.0, width: self.bounds.width, height: 26))
        terminalLbl.text = self.terminalName!
        terminalLbl.textAlignment = .Center
        terminalLbl.textColor = UIColor(red: 0.851, green: 0.4471, blue: 0.0902, alpha: 1.0) /* #d97217 */
        terminalLbl.font = UIFont.boldSystemFontOfSize(21.0)
        self.addSubview(terminalLbl)
    }
    
    func displayQueueService() {
        let serviceLbl = UILabel(frame: CGRect(x: 0, y: 144.0, width: self.bounds.width, height: 21))
        serviceLbl.text = self.serviceName!
        serviceLbl.textAlignment = .Center
        serviceLbl.textColor = UIColor.darkGrayColor()
        serviceLbl.font = UIFont.boldSystemFontOfSize(19.0)
        self.addSubview(serviceLbl)
    }
    
}
