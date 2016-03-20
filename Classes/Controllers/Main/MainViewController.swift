//
//  MainViewController.swift
//  flickrParty
//
//  Created by gunesmert on 20/03/16.
//  Copyright © 2016 Mert Ahmet Güneş. All rights reserved.
//

import UIKit
import PureLayout
import Kingfisher

let FeedCellReuseIdentifier = "FeedCellReuseIdentifier"

class MainViewController : BaseTableViewController {
    private var feedElements: [FeedElement]? = []
    
    private var pageNumber: NSNumber! = 1
    
    // MARK: - Constructors
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override init() {
        super.init()
        
        commonInit()
    }
    
    func commonInit() {
        
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        tableView.registerClass(FeedCell.classForCoder(), forCellReuseIdentifier: FeedCellReuseIdentifier)
        
        loadData(withRefresh: true)
    }
    
    // MARK: - Interface
    
    override func shouldShowLogoAsTitleView() -> Bool {
        return true
    }
    
    override func canPullToRefresh() -> Bool {
        return true
    }
    
    // MARK: - Data
    
    override func loadData(withRefresh refresh: Bool) -> Bool {
        if !super.loadData(withRefresh: refresh) {
            return false
        }
        
        if refresh == true {
            self.feedElements?.removeAll()
            
            pageNumber = 1
        } else {
            pageNumber = NSNumber(integer: pageNumber.integerValue + 1)
        }
        
        NetworkClient.sharedClient.getFeedElements(withPageNumber: pageNumber, withTags: ["party"]) { (pageNumber, numberOfPages, elements, error) -> Void in
            if error == nil {
                if pageNumber?.integerValue < numberOfPages?.integerValue {
                    self.canLoadMore = true
                } else {
                    self.canLoadMore = false
                }
                
                if refresh == true {
                    self.feedElements = elements
                } else {
                    for element in elements! {
                        self.feedElements?.append(element)
                    }
                }
                
                if self.feedElements?.count > 0 {
                    self.finishLoading(withMessage: nil, andStyle: StatusFooterViewStyle.None)
                } else {
                    self.finishLoading(withMessage: NSLocalizedString("There are no elements.\nPlease pull to refresh!", comment: ""), andStyle: StatusFooterViewStyle.Error)
                }
            } else {
                self.finishLoading(withMessage: NSLocalizedString("Unfortunately, we are not able to fetch feed elements. Please pull to refresh!", comment: ""), andStyle: StatusFooterViewStyle.Error)
            }
            
            if refresh == true {
                self.endRefreshing()
            }
            
            self.tableView.reloadData()
        }
        
        return true
    }
    
    // MARK: - UITableView Delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row >= feedElements?.count {
            return
        }
        
        let element = feedElements![indexPath.row]
        
        let detailViewController = DetailViewController(withElement: element)
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    // MARK: - UITableView DataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _ = feedElements else {
            return 0
        }
        
        return (feedElements?.count)!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(FeedCellReuseIdentifier, forIndexPath: indexPath) as! FeedCell
        
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        configure(PositionCell: cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row >= feedElements?.count {
            return 0.0
        }
        
        let element = feedElements![indexPath.row]
        
        let bundle = element.mediaBundle_z
        
        if bundle.width == nil || bundle.height == nil {
            return 200.0
        }
        
        return ((CGFloat(bundle.height!) * self.view.frame.size.width) / CGFloat(bundle.width!))
    }
    
    // MARK: - Cell Configuration
    
    func configure(PositionCell cell: FeedCell, atIndexPath indexPath: NSIndexPath) {
        if indexPath.row >= feedElements?.count {
            return
        }
        
        let element = feedElements![indexPath.row]
        
        let bundle = element.mediaBundle_z
        
        cell.feedImageView.kf_setImageWithURL(NSURL(string: bundle.urlString!)!)
        
        cell.tagsLabel.text = element.formattedTagsString
        
        cell.titleLabel.text = element.title
        
        cell.authorNameLabel.text = element.author
    }
}
