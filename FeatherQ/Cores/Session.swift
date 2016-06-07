//
//  Session.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 04/02/2016.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import Foundation

class Session {
    static let instance = Session()
    
    var fbId = ""
    var firstName = ""
    var lastName = ""
    var phone = ""
    var email = ""
    var address = ""
    var gender = ""
    var userId = ""
    var inQueue = false
    var checkedIn = false
    var longitude = 0.0
    var latitude = 0.0
    
    init(){
        
    }
}