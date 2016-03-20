//
//  BaseViewController.swift
//  flickrParty
//
//  Created by gunesmert on 20/03/16.
//  Copyright © 2016 Mert Ahmet Güneş. All rights reserved.
//

import UIKit

import PureLayout

class BaseViewController : UIViewController {
    private let instanceIdentifier = NSUUID.init().UUIDString;
    
    var isViewVisible: Bool {
        get {
            return (self.isViewLoaded() == true && self.view.window != nil)
        }
    }
    
    private var _customBackButton: UIButton!
    var customBackButton: UIButton {
        get {
            if(_customBackButton == nil) {
                _customBackButton = UIButton(type: UIButtonType.Custom)
                _customBackButton.frame = CGRectMake(0.0, 0.0, 8.0, 12.0)
                _customBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
                _customBackButton.setImage(UIImage(named: "navigationBarBackIcon"), forState: UIControlState.Normal)
                _customBackButton.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            }
            
            return _customBackButton
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.commonInit()
    }
    
    private func commonInit() {
        let dnc = NSNotificationCenter.defaultCenter()
        
        dnc.addObserver(self,
            selector: "didReceiveKeyboardWillShowNotification:",
            name: UIKeyboardWillShowNotification,
            object: nil)
        
        dnc.addObserver(self,
            selector: "didReceiveKeyboardWillHideNotification:",
            name: UIKeyboardWillHideNotification,
            object: nil)
        
        dnc.addObserver(self,
            selector: "didReceiveKeyboardDidShowNotification:",
            name: UIKeyboardDidShowNotification,
            object: nil)
        
        dnc.addObserver(self,
            selector: "didReceiveKeyboardDidHideNotification:",
            name: UIKeyboardDidHideNotification,
            object: nil)
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        if (shouldShowLogoAsTitleView() && shouldShowNavigationBar()) {
            let logo = UIImage(named: "logo")
            
            let logoView = UIImageView(frame: CGRectMake(0.0, 0.0, (logo?.size.width)!, (logo?.size.height)!))
            logoView.image = logo
            
            self.navigationItem.titleView = logoView
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(!shouldShowNavigationBar(), animated: true)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Keyboard Notifications
    
    func didReceiveKeyboardWillShowNotification(notification: NSNotification) {
        
    }
    
    func didReceiveKeyboardWillHideNotification(notification: NSNotification) {
        
    }
    
    func didReceiveKeyboardDidShowNotification(notification: NSNotification) {
        
    }
    
    func didReceiveKeyboardDidHideNotification(notification: NSNotification) {
        
    }
    
    // MARK: - Identifiers
    
    func uniqueIdentifier() -> String {
        return instanceIdentifier
    }
    
    // MARK: - Navigation
    
    func shouldShowLogoAsTitleView() -> Bool {
        return false
    }
    
    func shouldShowNavigationBar() -> Bool {
        return true
    }
    
    // MARK: - Button Actions
    
    func backButtonTapped(button: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
