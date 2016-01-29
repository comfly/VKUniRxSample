//
//  TweetsViewController.swift
//  TWTTR
//
//  Created by Dmitry Zakharov on 27/01/16.
//  Copyright © 2016 comfly. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


final class TweetsViewController: UITableViewController {

    private var tweets: [Tweet] = []
    private let dataSource = TweetsDataSource()
    private let dispose = DisposeBag()
    
    private var loading: Bool = false {
        didSet {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = loading
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeTableView()
    }
    
    private func customizeTableView() {
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = TweetLoadingFooter(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(tableView.bounds), height: 28))
    }
    
    private func showError(error: ErrorType) {
        NSLog("Error: \(error)")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(TweetCell), forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
 
    @IBAction func reloadTweets() {
        tweets.removeAll(keepCapacity: true)
        loadTweets()
    }
    
    private func loadTweets() {
        guard !loading else { return }
        
        loading = true
        
        let lastID = tweets.last?.id
        if lastID != nil {
            refreshControl!.beginRefreshing()
        }
        dataSource
            .loadTweetsFromID(lastID)
            .skip(lastID == nil ? 0 : 1)
            .observeOn(MainScheduler.instance)
            .subscribe(dispatchResult(tweets.count))
            .addDisposableTo(dispose)
    }

    private func dispatchResult(currentCount: Int) -> Event<Tweet> -> Void {
        return { [weak self]
            event in
            guard let sself = self else { return }

            if case .Next(let tweet) = event {
                sself.tweets.append(tweet)
            } else {
                sself.refreshControl!.endRefreshing()
                sself.loading = false

                switch event {
                case .Error(let error):
                    sself.showError(error)
                case .Completed:
                    if currentCount == 0 {
                        sself.tableView.reloadData()
                    } else {
                        let appendedRows = (currentCount..<sself.tweets.count).map { NSIndexPath(forRow: $0, inSection: 0) }
                        sself.tableView.insertRowsAtIndexPaths(appendedRows, withRowAnimation: .Automatic)
                    }
                case .Next(_): break // Processed
                }
            }
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + CGRectGetHeight(tableView.frame)) > CGRectGetMaxY(tableView.tableFooterView!.frame) {
            loadTweets()
        }
    }
}
