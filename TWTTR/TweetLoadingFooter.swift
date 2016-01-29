//
//  TweetLoadingFooter.swift
//  TWTTR
//
//  Created by Dmitry Zakharov on 28/01/16.
//  Copyright © 2016 comfly. All rights reserved.
//

import UIKit

final class TweetLoadingFooter: UIView {

    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createSubviews() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        addSubview(activityIndicator)
        
        addConstraints([
            NSLayoutConstraint(
                item: activityIndicator,
                attribute: .CenterXWithinMargins,
                relatedBy: .Equal,
                toItem: self,
                attribute: .CenterX,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(
                item: activityIndicator,
                attribute: .CenterYWithinMargins,
                relatedBy: .Equal,
                toItem: self,
                attribute: .CenterY,
                multiplier: 1,
                constant: 0)
        ])
        
        activityIndicator.startAnimating()
    }
    
}
