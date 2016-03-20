//
//  BaseTableViewController.swift
//  flickrParty
//
//  Created by gunesmert on 20/03/16.
//  Copyright © 2016 Mert Ahmet Güneş. All rights reserved.
//

import UIKit
import PureLayout

class BaseTableViewController : BaseViewController {
    var tableView: UITableView!
    
    var loadInProgress: Bool! = false
    var canLoadMore: Bool! = false
    
    private var loadIndicatorView: UIActivityIndicatorView!
    private var emptyStateView: StatusFooterView!
    private var refreshControl: UIRefreshControl!
    
    // MARK: - Constructors
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.view.addSubview(tableView)
        self.view.sendSubviewToBack(tableView)
        
        if canPullToRefresh() == true {
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
            
            tableView.addSubview(refreshControl)
        }
    }
    
    // MARK: - Loading
    
    func loadData(withRefresh refresh: Bool) -> Bool {
        if (loadInProgress == true) {
            return false
        }
        
        loadInProgress = true
        
        if (self.numberOfSectionsInTableView(tableView) == 0) {
            tableView.alpha = 0.0
            
            if (loadIndicatorView == nil) {
                loadIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
                loadIndicatorView.hidesWhenStopped = true
                loadIndicatorView.translatesAutoresizingMaskIntoConstraints = false
                
                self.view.addSubview(loadIndicatorView)
                
                loadIndicatorView.autoCenterInSuperview()
            }
            
            loadIndicatorView.alpha = 1.0
            
            if (emptyStateView != nil) {
                emptyStateView.alpha = 0.0
            }
            
            loadIndicatorView.startAnimating()
        } else {
            displayFooter(withMessage: nil, andStyle: StatusFooterViewStyle.Loader)
        }
        
        return true
    }
    
    func finishLoading(withMessage message: String?, andStyle style: StatusFooterViewStyle) {
        if (self.numberOfSectionsInTableView(tableView) == 0) {
            if (emptyStateView == nil) {
                emptyStateView = StatusFooterView.newAutoLayoutView()
                emptyStateView.delegate = self
                
                self.view.addSubview(emptyStateView)
                
                emptyStateView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
            }
            
            emptyStateView.set(style: style, andMessage: message)
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.emptyStateView.alpha = 1.0
                
                self.loadIndicatorView.alpha = 0.0
                }, completion: { (finished) -> Void in
                    self.loadIndicatorView.stopAnimating()
            })
            
            displayFooter(withMessage: nil, andStyle: StatusFooterViewStyle.None)
        } else {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.tableView.alpha = 1.0
                
                self.emptyStateView?.alpha = 0.0
                
                self.loadIndicatorView?.alpha = 0.0
                }, completion: { (finished) -> Void in
                    self.loadIndicatorView?.stopAnimating()
            })
            
            displayFooter(withMessage: message, andStyle: style)
        }
        
        loadInProgress = false
    }
    
    func displayFooter(withMessage message: String?, andStyle style: StatusFooterViewStyle) {
        if (style == StatusFooterViewStyle.None && message == nil) {
            tableView.tableFooterView = UIView(frame: CGRectZero)
            
            return
        }
        
        let footerView = StatusFooterView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.size.width, height: 0.0))
        footerView.delegate = self
        
        var frame = footerView.frame
        var headerSize = CGSizeZero
        
        if (tableView.tableHeaderView != nil) {
            headerSize = (tableView.tableHeaderView?.frame.size)!
        }
        
        frame.origin.y = headerSize.height;
        
        var footerHeight = tableView.frame.size.height - headerSize.height - (tableView.contentInset.top + tableView.contentInset.bottom)
        
        if (footerHeight < 100.0) {
            footerHeight = 100.0
        }
        
        frame.size.height = footerHeight
        
        footerView.frame = frame
        footerView.set(style: style, andMessage: message)
        
        tableView.tableFooterView = footerView
    }
    
    // MARK: - Refresh
    
    func canPullToRefresh() -> Bool {
        return false
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        loadData(withRefresh: true)
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    // MARK: - Keyboard Notifications
    
    override func didReceiveKeyboardWillShowNotification(notification: NSNotification) {
        if (!isViewVisible) {
            return
        }
        
        let keyboardHeight = notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height
        var insets = tableView.contentInset
        
        insets.bottom = keyboardHeight! + 12.0
        
        tableView.contentInset = insets
        
        insets = tableView.scrollIndicatorInsets
        insets.bottom = keyboardHeight!
        
        tableView.scrollIndicatorInsets = insets
    }
    
    override func didReceiveKeyboardWillHideNotification(notification: NSNotification) {
        if (!isViewVisible) {
            return
        }
        
        var insets = tableView.contentInset
        
        insets.bottom = 0.0
        
        tableView.contentInset = insets
        
        insets = tableView.scrollIndicatorInsets
        insets.bottom = 0.0
        
        tableView.scrollIndicatorInsets = insets
    }
}

// MARK: - UITableView Delegate

extension BaseTableViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

// MARK: - UITableView DataSource

extension BaseTableViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK: - StatusFooterViewDelegate

extension BaseTableViewController: StatusFooterViewDelegate {
    
}

// MARK: - UIScrollViewDelegate

extension BaseTableViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView != tableView {
            return
        }
        
        if scrollView.contentSize.height < scrollView.frame.size.height {
            return
        }
        
        if loadInProgress == true || canLoadMore == false {
            return
        }
        
        if ((scrollView.contentSize.height - scrollView.frame.size.height) - scrollView.contentOffset.y < 10.0) {
            loadData(withRefresh: false)
        }
    }
}
