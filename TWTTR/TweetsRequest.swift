//
//  TweetsDataSource.swift
//  TWTTR
//
//  Created by Dmitry Zakharov on 27/01/16.
//  Copyright © 2016 comfly. All rights reserved.
//

import Foundation
import Social
import Accounts
import RxSwift


final class TweetsRequest {
    
    enum Errors: ErrorType {
        case UnableToLoadData
    }
    
    private let base = NSURL(string: "https://api.twitter.com/1.1/")!
    
    private let account: ACAccount
    init(account: ACAccount) {
        self.account = account
    }
    
    func loadTweets(fromID id: String?) -> Observable<NSData> {
        let url = NSURL(string: "statuses/home_timeline.json", relativeToURL: base)!
        return Observable.create {
            observer in

            let parameters: [NSObject: AnyObject]
            if let id = id {
                parameters = ["max_id": id, "count": 20, "exclude_replies": true]
            } else {
                parameters = [:]
            }
            
            let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: url, parameters: parameters)
            request.account = self.account
            let prepended = request.preparedURLRequest()!
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(prepended) {
                data, response, error in
                if let response = response as? NSHTTPURLResponse where response.statusCode != 200 {
                    NSLog("Status code: \(response.statusCode)")
                    observer.onError(Errors.UnableToLoadData)
                } else if let error = error {
                    observer.onError(error)
                } else if let data = data {
                    observer.onNext(data)
                    observer.onCompleted()
                } else {
                    observer.onCompleted()
                }
            }
            
            task.resume()
            
            return AnonymousDisposable { task.cancel() }
        }
    }
    
    func sendTweet(tweet: String) -> Observable<NSData> {
        let url = NSURL(string: "statuses/update.json", relativeToURL: base)!
        return Observable.create {
            observer in
            
            let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .POST, URL: url, parameters: ["status": tweet])
            request.account = self.account
            let prepended = request.preparedURLRequest()!
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(prepended) {
                data, response, error in
                if let response = response as? NSHTTPURLResponse where response.statusCode != 200 {
                    NSLog("Status code: \(response.statusCode)")
                    observer.onError(Errors.UnableToLoadData)
                } else if let error = error {
                    observer.onError(error)
                } else if let data = data {
                    observer.onNext(data)
                    observer.onCompleted()
                } else {
                    observer.onCompleted()
                }
            }
            
            task.resume()
            
            return AnonymousDisposable { task.cancel() }
        }
    }
    
}
