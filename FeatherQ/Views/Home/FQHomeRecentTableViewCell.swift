//
//  FQHomeRecentTableViewCell.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 24/01/2016.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit

class FQHomeRecentTableViewCell: UITableViewCell {

    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var dateLastProcessed: UILabel!
    @IBOutlet weak var currentNumber: UILabel!
    @IBOutlet weak var status: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
