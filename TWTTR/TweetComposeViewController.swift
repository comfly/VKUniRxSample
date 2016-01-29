//
//  TweetComposeViewController.swift
//  TWTTR
//
//  Created by Dmitry Zakharov on 29/01/16.
//  Copyright © 2016 comfly. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


final class TweetComposeViewController: UIViewController {

    private let disposeBag = DisposeBag()
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var charactersCounterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("doneTapped"))
        
        textView.rx_text
            .map { 1...144 ~= $0.characters.count }
            .bindTo(navigationItem.rightBarButtonItem!.rx_enabled)
            .addDisposableTo(disposeBag)
        
        textView.rx_text
            .map { String($0.characters.count) }
            .bindTo(charactersCounterLabel.rx_text)
            .addDisposableTo(disposeBag)
        
        NSNotificationCenter.defaultCenter().rx_notification(UIKeyboardWillShowNotification)
            .subscribeNext(processKeyboardShowup)
            .addDisposableTo(disposeBag)
    }
    
    private func processKeyboardShowup(notification: NSNotification) {
        let (frame, duration, curve) = keyboardAppearanceParameters(notification)
        let height = CGRectGetHeight(frame)
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions(rawValue: numericCast(curve)), animations: {
            self.textViewBottomConstraint.constant = -height
        }, completion: nil)
    }
    
    private func keyboardAppearanceParameters(notification: NSNotification) -> (frame: CGRect, duration: NSTimeInterval, curve: Int) {
        let userInfo = notification.userInfo!
        let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        let curve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! Int)
        return (frame, duration, curve)
    }
    
    override func viewDidAppear(animated: Bool) {
        textView.becomeFirstResponder()
    }

    func doneTapped() {
        TweetsDataSource().sendTweet(textView.text!)
            .observeOn(MainScheduler.instance)
            .subscribe(processResult)
            .addDisposableTo(disposeBag)
    }
    
    private func processResult(event: Event<Void>) {
        switch event {
        case .Completed: navigationController?.popViewControllerAnimated(true)
        case .Error(let error): showError(error)
        case .Next(_): break // Never sent.
        }
    }
    
    private func showError(error: ErrorType) {
        let controller = UIAlertController(title: "Error", message: "Unable to send tweet", preferredStyle: .Alert)
        controller.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        presentViewController(controller, animated: true, completion: nil)
    }
    
}
