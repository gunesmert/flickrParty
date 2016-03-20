//
//  DetailViewController.swift
//  flickrParty
//
//  Created by gunesmert on 20/03/16.
//  Copyright © 2016 Mert Ahmet Güneş. All rights reserved.
//

import UIKit
import PureLayout
import Kingfisher

private let componentMargin: CGFloat = 16.0

class DetailViewController : BaseScrollViewController {
    private var feedImageView: UIImageView!
    private var loadIndicatorView: UIActivityIndicatorView!
    
    private var titleLabel: UILabel!
    private var tagsLabel: UILabel!
    private var descriptionLabel: UILabel!
    
    private var element: FeedElement?
    
    // MARK: - Constructors
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override init() {
        super.init()
        
        commonInit()
    }
    
    init(withElement element: FeedElement) {
        super.init()
        
        self.element = element
        
        commonInit()
        
        self.title = element.author
    }
    
    func commonInit() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.customBackButton)
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedImageView = UIImageView.newAutoLayoutView()
        feedImageView.contentMode = UIViewContentMode.ScaleAspectFit
        feedImageView.clipsToBounds = true
        
        contentView.addSubview(feedImageView)
        
        feedImageView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: ALEdge.Bottom)
        
        loadIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        loadIndicatorView.hidesWhenStopped = true
        loadIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        feedImageView.addSubview(loadIndicatorView)
        
        loadIndicatorView.autoCenterInSuperview()
        
        
        let informationContentHolderView = UIView.newAutoLayoutView()
        
        contentView.addSubview(informationContentHolderView)
        
        informationContentHolderView.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: feedImageView)
        informationContentHolderView.autoPinEdgeToSuperviewEdge(ALEdge.Left)
        informationContentHolderView.autoPinEdgeToSuperviewEdge(ALEdge.Right)

        informationContentHolderView.autoPinEdge(ALEdge.Bottom, toEdge: ALEdge.Bottom, ofView: contentView)
        
        
        titleLabel = UILabel.newAutoLayoutView()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.lightFont(withSize: 16.0)
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.numberOfLines = 0
        
        informationContentHolderView.addSubview(titleLabel)
        
        titleLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: componentMargin, left: componentMargin, bottom: componentMargin, right: componentMargin), excludingEdge: ALEdge.Bottom)
        
        
        tagsLabel = UILabel.newAutoLayoutView()
        tagsLabel.textColor = UIColor.whiteColor()
        tagsLabel.font = UIFont.lightFont(withSize: 10.0)
        tagsLabel.textAlignment = NSTextAlignment.Center
        tagsLabel.numberOfLines = 0
        
        informationContentHolderView.addSubview(tagsLabel)
        
        tagsLabel.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: componentMargin)
        tagsLabel.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: componentMargin)
        tagsLabel.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: titleLabel, withOffset:componentMargin)
        
       
        descriptionLabel = UILabel.newAutoLayoutView()
        descriptionLabel.textColor = UIColor.whiteColor()
        descriptionLabel.font = UIFont.regularFont(withSize: 14.0)
        descriptionLabel.textAlignment = NSTextAlignment.Center
        descriptionLabel.numberOfLines = 0
        
        informationContentHolderView.addSubview(descriptionLabel)
        
        descriptionLabel.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: componentMargin)
        descriptionLabel.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: componentMargin)
        descriptionLabel.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: tagsLabel, withOffset:componentMargin)
        
        descriptionLabel.autoPinEdge(ALEdge.Bottom, toEdge: ALEdge.Bottom, ofView: informationContentHolderView, withOffset:-componentMargin)
        
        
        
        let bundle = element!.mediaBundle_l
        
        if bundle.width == nil || bundle.height == nil {
            feedImageView.autoSetDimension(ALDimension.Height, toSize: 200.0)
        } else {
            feedImageView.autoSetDimension(ALDimension.Height, toSize: ((CGFloat(bundle.height!) * self.view.frame.size.width) / CGFloat(bundle.width!)))
        }
        
        updateInterface()
    }
    
    // MARK: - Interface
    
    func updateInterface() {
        guard let _ = element else {
            return
        }
        
        let bundle = element!.mediaBundle_l
        
        loadIndicatorView.startAnimating()
        
        feedImageView.kf_setImageWithURL(NSURL(string: bundle.urlString!)!, placeholderImage: nil, optionsInfo: KingfisherOptionsInfo?.None) { (image, error, cacheType, imageURL) -> () in
            self.loadIndicatorView.stopAnimating()
        }
        
        tagsLabel.text = element!.formattedTagsString
        
        titleLabel.text = element!.title
        
        descriptionLabel.text = element!.description
    }
}
