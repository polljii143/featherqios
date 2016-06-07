//
//  FQTransaction.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 3/28/16.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import Foundation

class FQTransaction: FQModel {
    
    var business_id: String?
    var priorityNumber: String?
    var businessName: String?
    var rating: String?
    var status: String?
    var date: String?
    var email: String?
    var transactionNumber: String?
    var transactionLength: String?
    
    override init(modelAttr: [String : AnyObject]) {
        self.business_id = "\(modelAttr["business_id"]!)"
        self.priorityNumber = modelAttr["priority_number"] as? String
        self.businessName = modelAttr["business_name"] as? String
        self.rating = "\(modelAttr["rating"]!)"
        self.status = "\(modelAttr["status"]!)"
        self.date = "\(modelAttr["transaction_date"]!)"
        self.transactionNumber = "\(modelAttr["id"]!)"
        self.transactionLength = "\(modelAttr["transaction_length"]!)"
        
        super.init(modelAttr: modelAttr)
    }
    
}