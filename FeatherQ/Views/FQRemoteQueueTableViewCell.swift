//
//  FQRemoteQueueTableViewCell.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 4/20/16.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import UIKit

class FQRemoteQueueTableViewCell: UITableViewCell {

    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var getNumLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.getNumLbl.layer.cornerRadius = 10.0
        self.getNumLbl.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
