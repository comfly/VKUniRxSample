//
//  TweetsDataSource.swift
//  TWTTR
//
//  Created by Dmitry Zakharov on 28/01/16.
//  Copyright © 2016 comfly. All rights reserved.
//

import Foundation
import Accounts
import RxSwift

final class TweetsDataSource {
    
    func loadTweetsFromID(id: String?) -> Observable<Tweet> {
        return account().flatMapFirst(data(fromID: id)).flatMapFirst(tweets)
    }
    
    private func account() -> Observable<ACAccount> {
        return TwitterAccountProvider().obtainAccount()
    }
    
    private func data(fromID id: String?) -> ACAccount -> Observable<NSData> {
        return { TweetsRequest(account: $0).loadTweets(fromID: id) }
    }
    
    private func tweets(data: NSData) -> Observable<Tweet> {
        return TweetParser().parseData(data)
    }

    func sendTweet(tweet: String) -> Observable<Void> {
        return account().flatMapFirst(send(tweet)).flatMapFirst(sendResponse)
    }
    
    private func send(tweet: String) -> ACAccount -> Observable<NSData> {
        return { TweetsRequest(account: $0).sendTweet(tweet) }
    }
    
    private func sendResponse(data: NSData) -> Observable<Void> {
        return TweetParser().parseSendResponse(data)
    }
}
