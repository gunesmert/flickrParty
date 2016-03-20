//
//  BaseScrollViewController.swift
//  flickrParty
//
//  Created by gunesmert on 20/03/16.
//  Copyright © 2016 Mert Ahmet Güneş. All rights reserved.
//

import UIKit
import PureLayout

class BaseScrollViewController : BaseViewController {
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView.newAutoLayoutView()
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
        
        self.view.addSubview(scrollView)
        
        scrollView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        
        
        contentView = UIView.newAutoLayoutView()
        contentView.backgroundColor = UIColor.clearColor()
        
        self.scrollView .addSubview(contentView)
        
        contentView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        contentView.autoPinEdge(ALEdge.Leading, toEdge: ALEdge.Leading, ofView: self.view)
        contentView.autoPinEdge(ALEdge.Trailing, toEdge: ALEdge.Trailing, ofView: self.view)
    }
    
    // MARK: - Keyboard Notifications
    
    override func didReceiveKeyboardWillShowNotification(notification: NSNotification) {
        if (!isViewVisible) {
            return
        }
        
        let keyboardHeight = notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height
        var insets = scrollView.contentInset
        
        insets.bottom = keyboardHeight!
        
        scrollView.contentInset = insets
        
        insets = scrollView.scrollIndicatorInsets
        insets.bottom = keyboardHeight!
        
        scrollView.scrollIndicatorInsets = insets
    }
    
    override func didReceiveKeyboardWillHideNotification(notification: NSNotification) {
        if (!isViewVisible) {
            return
        }
        
        var insets = scrollView.contentInset
        
        insets.bottom = 0.0
        
        scrollView.contentInset = insets
        
        insets = scrollView.scrollIndicatorInsets
        insets.bottom = 0.0
        
        scrollView.scrollIndicatorInsets = insets
    }
}

