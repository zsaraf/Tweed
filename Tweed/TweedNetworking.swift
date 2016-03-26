//
//  TweedNetworking.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/26/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import UIKit
import AFNetworking

typealias TweedNetworkingSuccessHandler = ((task: NSURLSessionTask, responseObject: AnyObject) -> Void)
typealias TweedNetworkingFailureHandler = ((task: NSURLSessionTask, error: NSError) -> Void)

class TweedNetworking: NSObject {

    enum RequestMethod {
        case Post;
        case Get;
    }

    static func baseUrl() -> NSURL {
        return NSURL(string: "ec2-54-201-37-165.us-west-2.compute.amazonaws.com/django/")!
    }

    static func request(relativeUrl: String, method: RequestMethod, params: [String: AnyObject], successHandler: TweedNetworkingSuccessHandler?, failureHandler: TweedNetworkingFailureHandler?) {
//        let url = baseUrl().stringByAppendingString(relativeUrl)

        let manager = AFHTTPSessionManager(baseURL: baseUrl())
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()

        manager.requestSerializer.clearAuthorizationHeader()

        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        if method == .Post {
            manager.POST(relativeUrl, parameters: params, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) -> Void in
                successHandler?(task: task, responseObject: responseObject!)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failureHandler?(task: task!, error: error)
            })
        } else {
            manager.GET(relativeUrl, parameters: params, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) -> Void in
                successHandler?(task: task, responseObject: responseObject!)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failureHandler?(task: task!, error: error)
            })
        }
    }

    static func checkHandle(handle: String, successHandler: TweedNetworkingSuccessHandler?, failureHandler: TweedNetworkingFailureHandler) {

        self.request("check", method: .Post, params: ["handle": handle], successHandler: successHandler, failureHandler: failureHandler)
    }

}
