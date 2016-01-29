//
//  TweetCell.swift
//  TWTTR
//
//  Created by Dmitry Zakharov on 27/01/16.
//  Copyright © 2016 comfly. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


final class TweetCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var authorTextLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    var tweet: Tweet? = nil {
        didSet {
            updatePresentation()
        }
    }
    
    private func updatePresentation() {
        if let tweet = tweet {
            NSURLSession.sharedSession()
                .rx_data(NSURLRequest(URL: tweet.author.imageURL))
                .map(UIImage.init)
                .observeOn(MainScheduler.instance)
                .bindTo(avatarImageView.rx_image)
                .addDisposableTo(disposeBag)
            authorTextLabel.text = tweet.author.name
            tweetTextLabel.text = tweet.text
        } else {
            avatarImageView.image = nil
            authorTextLabel.text = nil
            tweetTextLabel.text = nil
        }
    }
    
    override func prepareForReuse() {
        tweet = nil
    }
}
