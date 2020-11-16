//
//  APIManager.swift
//  PolicyTracker
//
//  Created by Rupali Patil on 15/07/19.
//  Copyright © 2019 Nishikant Ashok UMBARKAR. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIManager
{
    static let sharedInstance = APIManager()
    private init(){}
    
    class func headers() -> HTTPHeaders {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        if let authToken = UserDefaults.standard.string(forKey: "auth_token") {
            headers["Authorization"] = "Token" + " " + authToken
        }
        
        return headers
    }

    func requestGETURL(_ strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        Alamofire.request(strURL).responseJSON { (responseObject) -> Void in
            
            switch responseObject.result
            {
            case .success(_):
                if let resJson = responseObject.result.value
                {
                    success(JSON(resJson))
                }
                break
                
            case .failure(_):
                let error : Error = responseObject.result.error!
                failure(error)
                break
            }
        }
    }
    
    func requestPOSTURL(_ strURL: String, params: [String : Any], success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        Alamofire.request(strURL, method: .post, parameters: params).responseJSON { (responseObject) -> Void in
            
            switch responseObject.result
            {
            case .success(_):
                if let resJson = responseObject.result.value
                {
                    success(JSON(resJson))
                }
                break
                
            case .failure(_):
                let error : Error = responseObject.result.error!
                failure(error)
                break
            }
        }
    }
    
}
