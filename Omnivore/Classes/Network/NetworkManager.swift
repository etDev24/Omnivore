//
//  NetworkManager.swift
//  Omnivore Demo
//
//  Created by apple on 2/27/18.
//  Copyright © 2018 Muhammad Umair. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager: NSObject {
    
    func request(requestType:HTTPMethod ,requestString: String, body: [String: AnyObject]?, headers:HTTPHeaders, encoding : ParameterEncoding, completion: @escaping (_ response: DataResponse<Any>, _ statusCode: Int?, _ data: AnyObject?) -> ())
    {
        Alamofire.request(requestString, method: requestType, parameters: body, encoding: encoding, headers: headers).responseJSON(completionHandler:
            {
                response in
                
                if(response.request?.httpBody != nil)
                {
                    print(String(data:(response.request?.httpBody)!, encoding: String.Encoding.utf8)!)
                }
                
                print("Response - \(String(describing: response.response))") // HTTP URL response
                print("DATA - \(String(describing: response.data))")     // server data
                print("result - \(response.result)")   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                if response.response != nil {
                    completion(response, response.response?.statusCode, response.result.value as AnyObject?)
                } else {
                    completion(response, -1, response.result.value as AnyObject?)
                }
        })
    }
    
}
