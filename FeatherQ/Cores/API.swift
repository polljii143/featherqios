//
//  API.swift
//  FeatherQ
//
//  Created by Paul Andrew Gutib on 21/01/2016.
//  Copyright © 2016 Paul Andrew Gutib. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Locksmith

enum Router: URLRequestConvertible{
    static let baseURL = "http://four.featherq.com"
    //static let clientId = "fqiosapp" //use in OAuth
    //static let clientSecret = "fqiosapp" //use in OAuth
    
    case getActiveBusinesses
    case getAllBusiness
    case getPopularBusiness
    case getSearchBusiness(query: String, latitude: String, longitude: String)
    case getActivebusinessDetails(latitude: String, longitude: String)
    case getRandomBusiness
    case getBusinessDetail(id: String)
    case getActiveBusiness
    case getShowNumber(businessId: String)
    case postRegisterUser(fbId: String, firstName: String, lastName: String, email: String, gender: String)
    case getUpdateContactCountry
    case getUserIndustryInfo(facebookId: String, limit: String)
    case getQueueInfo(facebookId: String, businessId: String)
    case getSearchIndustry(query: String)
    case getQueueBusiness(facebookId: String, businessId: String)
    case getMyAllHistory(userId: String)
    case getMyBusinessHistory(transactionNumber: String)
    case getRateBusiness(rating: String, facebookId: String, businessId: String, transactionNumber: String)
    case getTransactionRatingInfo(transactionNumber: String)
    case getIndustries
    case postFacebookLogin(fbId: String)
    case getBusinessServiceDetails(facebookId: String)
    case getQueueNumber(serviceId: String, name: String, phone: String, email: String)
    case getAllMessages(facebookId: String)
    case getBusinessMessages(facebookId: String, businessId: String)
    case postSendtoBusiness(facebookId: String, businessId: String, message: String, phone: String)
    case getTransactionStats(transactionNumber: String)
    case getBroadcastNumbers(businessId: String)
    case getBusinessNumbers(businessId: String, userId: String)
    case getQueueService(userId: String, serviceId: String)
    case getCheckedIn(transactionNumber: String)
    case getCheckinTransaction(transactionNumber: String)
    case getUserQueue(userId: String)
    case postSendMessage(userId: String, businessId: String, message: String)
    case getBusinessBroadcast(businessId: String, userId: String)
    case getFormElements(businessId: String)
    
    var method: Alamofire.Method {
        switch self {
        case .postSendtoBusiness:
            return .POST
        case .postRegisterUser:
            return .POST
        case .postFacebookLogin:
            return .POST
        case .postSendMessage:
            return .POST
        default:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .postFacebookLogin:
            return "/mobile/facebook-login"
        case .getAllBusiness:
            return "/rest/all-business"
        case .getActiveBusinesses:
            return "/mobile/active-businesses"
        case .getSearchBusiness(let query, let latitude, let longitude):
            return "/rest/search-business/" + query + "/" + latitude + "/" + longitude
        case .getActivebusinessDetails(let latitude, let longitude):
            return "/rest/activebusiness-details/" + latitude + "/" + longitude
        case .getRandomBusiness:
            return "/rest/random-business"
        case .getBusinessDetail(let id):
            return "/rest/business-detail/" + id
        case .getActiveBusiness:
            return "/rest/active-business"
        case .getShowNumber(let businessId):
            return "/rest/show-number/" + businessId
        case .getUpdateContactCountry:
            return "/rest/update-contact-country"
        case .getUserIndustryInfo(let facebookId, let limit):
            return "/rest/user-industry-info/" + facebookId + "/" + limit
        case .getQueueInfo(let facebookId, let businessId):
            return "/rest/queue-info/" + facebookId + "/" + businessId
        case .getSearchIndustry(let query):
            return "/rest/search-industry/" + query
        case .getQueueBusiness(let facebookId, let businessId):
            return "/rest/queue-business/" + facebookId + "/" + businessId
        case .getMyAllHistory(let userId):
            return "/mobile/my-all-history/" + userId + "/20"
        case .getMyBusinessHistory(let transactionNumber):
            return "/mobile/my-business-history/" + transactionNumber
        case .getRateBusiness(let rating, let facebookId, let businessId, let transactionNumber):
            return "/rest/rate-business/" + rating + "/" + facebookId + "/" + businessId + "/" + transactionNumber + "/4"
        case .getTransactionRatingInfo(let transactionNumber):
            return "/rest/transaction-rating-info/" + transactionNumber
        case .getIndustries:
            return "/rest/industries"
        case .getBusinessServiceDetails(let facebookId):
            return "/rest/business-service-details/" + facebookId
        case .getQueueNumber(let serviceId, let name, let phone, let email):
            return "/rest/queue-number/" + serviceId + "/" + name + "/" + phone + "/" + email
        case .getAllMessages(let facebookId):
            return "/rest/all-messages/" + facebookId
        case .getBusinessMessages(let facebookId, let businessId):
            return "/rest/business-messages/" + facebookId + "/" + businessId
        case .postSendtoBusiness:
            return "/rest/sendto-business"
        case .postRegisterUser:
            return "/rest/register-user"
        case .getPopularBusiness:
            return "/rest/popular-business"
        case .getBroadcastNumbers(let businessId):
            return "/json/"+businessId+".json"
        case .getBusinessNumbers(let businessId, let userId):
            return "/mobile/business-numbers/" + businessId + "/" + userId
        case .getQueueService(let userId, let serviceId):
            return "/rest/queue-service/" + userId + "/" + serviceId
        case .getCheckedIn(let transactionNumber):
            return "/mobile/checked-in/" + transactionNumber
        case .getCheckinTransaction(let transactionNumber):
            return "/mobile/checkin-transaction/" + transactionNumber
        case .getUserQueue(let userId):
            return "/mobile/user-queue/" + userId
        case .postSendMessage:
            return "/mobile/send-message"
        case .getBusinessBroadcast(let businessId, let userId):
            return "/mobile/business-broadcast/" + businessId + "/" + userId
        case .getFormElements(let businessId):
            return "/forms/fields/" + businessId
        default:
            return "/"
        }
    }
    
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: Router.baseURL)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        mutableURLRequest.HTTPMethod = method.rawValue
        
        debugPrint(mutableURLRequest.URLString)
        
        /*
        switch self{
        case .getUserInfo:
            break
        default:
            let dictionary = Locksmith.loadDataForUserAccount("fqiosapp")
            if dictionary != nil {
                let token = dictionary!["access_token"] as! String
                debugPrint(token)
                //mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // will implement this once we have OAuth
            }
            break
        }*/
        
        switch self {
        case .postSendtoBusiness(let facebookId, let businessId, let message, let phone):
            let params = [
                "facebook_id": facebookId,
                "business_id": businessId,
                "message": message,
                "phone": phone
            ]
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
        case .postRegisterUser(let fbId, let firstName, let lastName, let email, let gender):
            let params = [
                "fb_id": fbId,
                "first_name": firstName,
                "last_name": lastName,
                "email": email,
                "gender": gender,
                "phone": "",
                "country": ""
            ]
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
        case .postFacebookLogin(let fbId):
            let params = [
                "facebook_id": fbId
            ]
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
        case .postSendMessage(let userId, let businessId, let message):
            let params = [
                "user_id": userId,
                "business_id": businessId,
                "message": message
            ]
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
        default:
            return mutableURLRequest
        }
    }
}