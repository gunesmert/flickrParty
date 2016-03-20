//
//  StatusFooterView.swift
//  flickrParty
//
//  Created by gunesmert on 20/03/16.
//  Copyright © 2016 Mert Ahmet Güneş. All rights reserved.
//

import UIKit
import PureLayout

enum StatusFooterViewStyle {
    case None
    case Loader
    case Error
}

class StatusFooterView: UICollectionReusableView {
    weak var delegate: StatusFooterViewDelegate!
    
    private var componentsHolderView: UIView!
    
    private var messageLabel: UILabel!
    private var loadIndicator: UIActivityIndicatorView!
    private var style: StatusFooterViewStyle!
    
    // MARK: - Constructors
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = UIColor.clearColor()
        
        componentsHolderView = UIView.newAutoLayoutView()
        
        self.addSubview(componentsHolderView)
        
        componentsHolderView.autoAlignAxisToSuperviewAxis(ALAxis.Horizontal)
        componentsHolderView.autoPinEdgeToSuperviewEdge(ALEdge.Left)
        componentsHolderView.autoPinEdgeToSuperviewEdge(ALEdge.Right)
        componentsHolderView.autoSetDimension(ALDimension.Height, toSize: 130.0)
        
        let boxIcon = UIImageView.newAutoLayoutView()
        boxIcon.contentMode = UIViewContentMode.Center
        boxIcon.image = UIImage(named: "emptyBoxIcon")
        
        componentsHolderView.addSubview(boxIcon)
        
        boxIcon.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: ALEdge.Bottom)
        boxIcon.autoSetDimension(ALDimension.Height, toSize: 70.0)
        
        
        let line = UIView.newAutoLayoutView()
        line.backgroundColor = UIColor.lightGraySeparatorColor()
        
        componentsHolderView.addSubview(line)
        
        line.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: boxIcon)
        line.autoAlignAxisToSuperviewAxis(ALAxis.Vertical)
        line.autoSetDimensionsToSize(CGSize(width: 200.0, height: 1.0))
        
        
        messageLabel = UILabel.newAutoLayoutView()
        messageLabel.textColor = UIColor.lightGrayTextColor()
        messageLabel.font = UIFont.lightFont(withSize: 14.0)
        messageLabel.textAlignment = NSTextAlignment.Center
        messageLabel.numberOfLines = 0
        
        componentsHolderView.addSubview(messageLabel)
        
        messageLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0.0, left: 40.0, bottom: 0.0, right: 40.0), excludingEdge: ALEdge.Top)
        messageLabel.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: line)
        
        
        loadIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        loadIndicator.hidesWhenStopped = true
        loadIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(loadIndicator)
        
        loadIndicator.autoCenterInSuperview()
        
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "didTriggerTapGestureRecognizer:"))
    }
    
    // MARK: - Content Update
    
    func set(style style: StatusFooterViewStyle, andMessage message: String?) {
        self.style = style
        
        messageLabel.text = message
        
        switch style {
        case .None:
            componentsHolderView.hidden = false
            
            loadIndicator.stopAnimating()
        case .Loader:
            componentsHolderView.hidden = true
            
            loadIndicator.startAnimating()
        default:
            break
        }
    }
    
    // MARK: - Gesture Recognizer
    
    func didTriggerTapGestureRecognizer(recognizer: UITapGestureRecognizer) {
        if (style == StatusFooterViewStyle.Error) {
            if (delegate.respondsToSelector("footerViewDidTapRetry") == true) {
                delegate.footerViewDidTapRetry!(footerView: self)
            }
        } else {
            if (delegate.respondsToSelector("footerViewDidTap") == true) {
                delegate.footerViewDidTap!(footerView: self)
            }
        }
    }
}

@objc protocol StatusFooterViewDelegate: NSObjectProtocol {
    optional func footerViewDidTap(footerView footerView: StatusFooterView)
    optional func footerViewDidTapRetry(footerView footerView: StatusFooterView)
}
