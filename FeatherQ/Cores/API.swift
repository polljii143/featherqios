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
//    static let baseURL = "http://four.featherq.com"
    static let baseURL = "http://new-featherq.local"
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
    case postRegisterUser(fb_id: String, first_name: String, last_name: String, email: String, gender: String)
    case getUpdateContactCountry
    case getUserIndustryInfo(facebookId: String, limit: String)
    case getQueueInfo(facebookId: String, businessId: String)
    case getSearchIndustry(query: String)
    case getQueueBusiness(facebookId: String, businessId: String)
    case getMyAllHistory(user_id: String)
    case getMyBusinessHistory(transaction_number: String)
    case getRateBusiness(rating: String, facebookId: String, businessId: String, transactionNumber: String)
    case getTransactionRatingInfo(transactionNumber: String)
    case getIndustries
    case postFacebookLogin(fb_id: String)
    case getBusinessServiceDetails(facebookId: String)
    case getQueueNumber(serviceId: String, name: String, phone: String, email: String)
    case getAllMessages(facebookId: String)
    case getBusinessMessages(facebookId: String, businessId: String)
    case postSendtoBusiness(facebookId: String, businessId: String, message: String, phone: String)
    case getTransactionStats(transactionNumber: String)
    case getBroadcastNumbers(business_id: String)
    case getBusinessNumbers(business_id: String, user_id: String)
    case getQueueService(user_id: String, service_id: String)
    case getCheckedIn(transaction_number: String)
    case getCheckinTransaction(transaction_number: String)
    case getUserQueue(user_id: String)
    case postSendMessage(user_id: String, business_id: String, message: String)
    case getBusinessBroadcast(business_id: String, user_id: String)
    case getViewForm(form_id: String)
    case getDisplayForms(serviceId: String)
    case getServiceEstimates(serviceId: String)
    case getUserRecords(transactionNumber: String)
    case getViewRecord(recordId: String)
    case postSubmitForm(userId: String, transactionNumber: String, formSubmissions: [[String:[[String:String]]]], serviceId: String, serviceName: String)
    
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
        case .postSubmitForm:
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
        case .getMyAllHistory(let user_id):
            return "/mobile/my-all-history/" + user_id + "/20"
        case .getMyBusinessHistory(let transaction_number):
            return "/mobile/my-business-history/" + transaction_number
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
        case .getBroadcastNumbers(let business_id):
            return "/json/"+business_id+".json"
        case .getBusinessNumbers(let business_id, let user_id):
            return "/mobile/business-numbers/" + business_id + "/" + user_id
        case .getQueueService(let user_id, let service_id):
            return "/rest/queue-service/" + user_id + "/" + service_id
        case .getCheckedIn(let transaction_number):
            return "/mobile/checked-in/" + transaction_number
        case .getCheckinTransaction(let transaction_number):
            return "/mobile/checkin-transaction/" + transaction_number
        case .getUserQueue(let user_id):
            return "/mobile/user-queue/" + user_id
        case .postSendMessage:
            return "/mobile/send-message"
        case .getBusinessBroadcast(let business_id, let user_id):
            return "/mobile/business-broadcast/" + business_id + "/" + user_id
        case .getViewForm(let form_id):
            return "/mobile/view-form/" + form_id
        case .getDisplayForms(let serviceId):
            return "/mobile/display-forms/" + serviceId
        case .getServiceEstimates(let serviceId):
            return "/mobile/service-estimates/" + serviceId
        case .getUserRecords(let transactionNumber):
            return "/mobile/user-records/" + transactionNumber
        case .getViewRecord(let recordId):
            return "/mobile/view-record/" + recordId
        case .postSubmitForm:
            return "/mobile/submit-form"
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
        case .postRegisterUser(let fb_id, let first_name, let last_name, let email, let gender):
            let params = [
                "fb_id": fb_id,
                "first_name": first_name,
                "last_name": last_name,
                "email": email,
                "gender": gender,
                "phone": "",
                "country": ""
            ]
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
        case .postFacebookLogin(let fb_id):
            let params = [
                "facebook_id": fb_id
            ]
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
        case .postSendMessage(let user_id, let business_id, let message):
            let params = [
                "user_id": user_id,
                "business_id": business_id,
                "message": message
            ]
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
        case .postSubmitForm(let userId, let transactionNumber, let formSubmissions, let serviceId, let serviceName):
            let params = [
                "user_id": userId,
                "transaction_number": transactionNumber,
                "form_submissions": formSubmissions,
                "service_id": serviceId,
                "service_name": serviceName
            ]
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: params as? [String : AnyObject]).0
        default:
            return mutableURLRequest
        }
    }
}