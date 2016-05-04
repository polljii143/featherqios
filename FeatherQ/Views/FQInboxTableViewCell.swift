//
//  FQInboxTableViewCell.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 4/27/16.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit

class FQInboxTableViewCell: UITableViewCell {

    @IBOutlet weak var fromBusiness: UILabel!
    @IBOutlet weak var fromYou: UILabel!
    @IBOutlet weak var businessBubble: UIImageView!
    @IBOutlet weak var userBubble: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
