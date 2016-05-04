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
    var priority_number: String?
    var business_name: String?
    var rating: String?
    var status: String?
    var date: String?
    var email: String?
    var transaction_number: String?
    var transaction_length: String?
    
    override init(modelAttr: [String : AnyObject]) {
        self.business_id = "\(modelAttr["business_id"]!)"
        self.priority_number = modelAttr["priority_number"] as? String
        self.business_name = modelAttr["business_name"] as? String
        self.rating = "\(modelAttr["rating"]!)"
        self.status = "\(modelAttr["status"]!)"
        self.date = "\(modelAttr["transaction_date"]!)"
        self.transaction_number = "\(modelAttr["id"]!)"
        self.transaction_length = "\(modelAttr["transaction_length"]!)"
        
        super.init(modelAttr: modelAttr)
    }
    
}