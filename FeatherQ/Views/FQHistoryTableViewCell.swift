//
//  FQHistoryTableViewCell.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 4/21/16.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit

class FQHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var dateLastProcessed: UILabel!
    @IBOutlet weak var currentNumber: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var businessLogo: UIImageView!
    @IBOutlet weak var ratingBtn1: UIButton!
    @IBOutlet weak var ratingBtn2: UIButton!
    @IBOutlet weak var ratingBtn3: UIButton!
    @IBOutlet weak var ratingBtn4: UIButton!
    @IBOutlet weak var ratingBtn5: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
