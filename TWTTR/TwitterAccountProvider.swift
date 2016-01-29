//
//  TwitterAccountProvider.swift
//  TWTTR
//
//  Created by Dmitry Zakharov on 28/01/16.
//  Copyright © 2016 comfly. All rights reserved.
//

import Foundation
import Accounts
import RxSwift


final class TwitterAccountProvider {
    
    func obtainAccount() -> Observable<ACAccount> {
        return Observable.create {
            observer in
            
            let store = ACAccountStore()
            let accountType = store.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
            
            store.requestAccessToAccountsWithType(accountType, options: nil) {
                granted, error in
                if granted {
                    if let accounts = store.accountsWithAccountType(accountType) as? [ACAccount], account = accounts.first {
                        observer.onNext(account)
                    }
                    observer.onCompleted()
                } else if let error = error {
                    observer.onError(error)
                }
            }
            
            return AnonymousDisposable { }
        }
    }
    
}
