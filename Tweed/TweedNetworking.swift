//
//  TweedNetworking.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/26/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//
import UIKit
import AFNetworking

typealias TweedNetworkingSuccessHandler = ((task: NSURLSessionTask, responseObject: AnyObject?) -> Void)
typealias TweedNetworkingFailureHandler = ((task: NSURLSessionTask, error: NSError) -> Void)

class TweedNetworking: NSObject {

    enum RequestMethod {
        case Post;
        case Get;
    }

    static func baseUrl() -> NSURL {
        return NSURL(string: "http://ec2-54-187-159-146.us-west-2.compute.amazonaws.com/django/")!
    }

    static func request(relativeUrl: String, method: RequestMethod, params: [String: AnyObject], successHandler: TweedNetworkingSuccessHandler?, failureHandler: TweedNetworkingFailureHandler?) {

        let manager = AFHTTPSessionManager(baseURL: baseUrl())
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()

        manager.requestSerializer.clearAuthorizationHeader()
        if TweedAuthManager.sharedManager().isValidSession() {
            manager.requestSerializer.setValue(TweedAuthManager.sharedManager().accessToken(), forHTTPHeaderField: "X-Session-Id")
        }

        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        if method == .Post {
            manager.POST(relativeUrl, parameters: params, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) -> Void in
                successHandler?(task: task, responseObject: responseObject)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failureHandler?(task: task!, error: error)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
        } else {
            manager.GET(relativeUrl, parameters: params, success: { (task: NSURLSessionDataTask, responseObject: AnyObject?) -> Void in
                successHandler?(task: task, responseObject: responseObject)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failureHandler?(task: task!, error: error)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
        }
    }

    static func checkHandle(handle: String, successHandler: TweedNetworkingSuccessHandler?, failureHandler: TweedNetworkingFailureHandler) {
        self.request("accounts/follows/check_user", method: .Get, params: ["screen_name": handle], successHandler: successHandler, failureHandler: failureHandler)
    }

    static func getAnonymousToken(successHandler: TweedNetworkingSuccessHandler?, failureHandler: TweedNetworkingFailureHandler) {
        self.request("accounts/tokens/", method: .Post, params: [String: AnyObject](), successHandler: successHandler, failureHandler: failureHandler)
    }
    
    static func getSuggestions(successHandler: TweedNetworkingSuccessHandler?, failureHandler: TweedNetworkingFailureHandler) {
        self.request("accounts/follows/get_suggestions", method: .Get, params: [String: AnyObject](), successHandler: successHandler, failureHandler: failureHandler)
    }

    static func refreshTweets(successHandler: TweedNetworkingSuccessHandler?, failureHandler: TweedNetworkingFailureHandler) {
        self.request("accounts/users/refresh/", method: .Post, params: [String: AnyObject](), successHandler: successHandler, failureHandler: failureHandler)
    }

    static func editHandles(additions: [String], deletions: [String], successHandler: TweedNetworkingSuccessHandler?, failureHandler: TweedNetworkingFailureHandler) {
        self.request("accounts/follows/edit/", method: .Post, params: ["additions": additions, "deletions": deletions], successHandler: successHandler, failureHandler: failureHandler)
    }

}
