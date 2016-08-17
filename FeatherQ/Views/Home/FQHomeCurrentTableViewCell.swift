//
//  FQHomeCurrentTableViewCell.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 4/26/16.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit
import QuartzCore

class FQHomeCurrentTableViewCell: UITableViewCell {

    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var businessAddress: UILabel!
    @IBOutlet weak var nowServing: UILabel!
    @IBOutlet weak var timeLeft: UILabel!
    @IBOutlet weak var awayDistance: UILabel!
    @IBOutlet weak var yourNumber: UILabel!
    @IBOutlet weak var checkInBtn: UIButton!
    @IBOutlet weak var checkInLbl: UILabel!
    @IBOutlet weak var currentNum: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.checkInLbl.layer.cornerRadius = 10.0
        self.checkInLbl.clipsToBounds = true
    }
    
}
