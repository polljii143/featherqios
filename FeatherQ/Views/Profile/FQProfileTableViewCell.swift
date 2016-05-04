//
//  FQAboutTableViewCell.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 02/02/2016.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit

class FQProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var profileData: UILabel!
    @IBOutlet weak var profileTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
