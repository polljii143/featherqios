//
//  FQHomeTableViewCell.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 4/20/16.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit

class FQHomeTableViewCell: UITableViewCell {

    @IBOutlet weak var businessLogo: UIImageView!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var businessAddress: UILabel!
    @IBOutlet weak var nowServing: UILabel!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
