//
//  FQBusiness.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 22/01/2016.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import Foundation

class FQBusiness: FQModel {
    
    var businessId: String?
    var name: String?
    var localAddress: String?
    var latitude: String?
    var longitude: String?
    var distance: String?
    var lastCalledNumber: String?
    var lastCalledService: String?
    
    override init(modelAttr: [String : AnyObject]) {
        let formatter = NSNumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .DecimalStyle
        
        self.businessId = "\(modelAttr["business_id"]!)"
        self.name = modelAttr["name"] as? String
        self.localAddress = modelAttr["local_address"] as? String
        self.latitude = "\(modelAttr["latitude"]!)"
        self.longitude = "\(modelAttr["longitude"]!)"
        self.distance = formatter.stringFromNumber(Float("\(modelAttr["distance"]!)")!)
        self.lastCalledNumber = modelAttr["last_called_number"] as? String
        self.lastCalledService = modelAttr["last_called_service"] as? String
        
        super.init(modelAttr: modelAttr)
    }
    
}