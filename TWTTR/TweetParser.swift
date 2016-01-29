//
//  TweetParser.swift
//  TWTTR
//
//  Created by Dmitry Zakharov on 27/01/16.
//  Copyright © 2016 comfly. All rights reserved.
//

import Foundation
import RxSwift


final class TweetParser {
    
    enum Errors: ErrorType {
        case UnableToParseData
        case TweetSendingError
    }
    
    func parseData(data: NSData) -> Observable<Tweet> {
        return Observable.create {
            observer in
            do {
                if let objects = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? Array<[String: AnyObject]> {
                    for tweet in objects.flatMap(Tweet.init) {
                        observer.onNext(tweet)
                    }
                    observer.onCompleted()
                } else {
                    throw Errors.UnableToParseData
                }
            } catch {
                observer.onError(error)
            }
            
            return AnonymousDisposable { }
        }
    }
    
    func parseSendResponse(data: NSData) -> Observable<Void> {
        return Observable.create {
            observer in
            do {
                if let object = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject],
                   let tweet = Tweet(fromDictionary: object) where !tweet.id.isEmpty {
                    observer.onCompleted()
                } else {
                    throw Errors.TweetSendingError
                }
            } catch {
                observer.onError(error)
            }
            
            return AnonymousDisposable { }
        }
    }
}
