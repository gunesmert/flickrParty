//
//  FeedCell.swift
//  flickrParty
//
//  Created by gunesmert on 20/03/16.
//  Copyright © 2016 Mert Ahmet Güneş. All rights reserved.
//

import UIKit
import PureLayout

private let componentMargin: CGFloat = 16.0

class FeedCell: UITableViewCell {
    var feedImageView: UIImageView!
    
    var authorNameLabel: UILabel!
    var titleLabel: UILabel!
    var tagsLabel: UILabel!
    
    // MARK: - Constructors
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        feedImageView = UIImageView.newAutoLayoutView()
        feedImageView.contentMode = UIViewContentMode.ScaleAspectFit
        feedImageView.clipsToBounds = true
        
        contentView.addSubview(feedImageView)
        
        feedImageView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        
        
        let shadowImage = UIImageView.newAutoLayoutView()
        shadowImage.image = UIImage(named: "textShadow")
        
        contentView.addSubview(shadowImage)
        
        shadowImage.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: ALEdge.Top)
        shadowImage.autoSetDimension(ALDimension.Height, toSize: 160.0)
        
        
        tagsLabel = UILabel.newAutoLayoutView()
        tagsLabel.textColor = UIColor.whiteColor()
        tagsLabel.font = UIFont.lightFont(withSize: 8.0)
        tagsLabel.numberOfLines = 0
        
        contentView.addSubview(tagsLabel)
        
        tagsLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0.0, left: componentMargin, bottom: componentMargin, right: componentMargin), excludingEdge: ALEdge.Top)
        
        
        titleLabel = UILabel.newAutoLayoutView()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.lightFont(withSize: 12.0)
        titleLabel.numberOfLines = 0
        
        contentView.addSubview(titleLabel)
        
        titleLabel.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: componentMargin)
        titleLabel.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: componentMargin)
        titleLabel.autoPinEdge(ALEdge.Bottom, toEdge: ALEdge.Top, ofView: tagsLabel, withOffset: -componentMargin / 2)
        
        
        authorNameLabel = UILabel.newAutoLayoutView()
        authorNameLabel.textColor = UIColor.whiteColor()
        authorNameLabel.font = UIFont.mediumFont(withSize: 16.0)
        authorNameLabel.numberOfLines = 0
        
        contentView.addSubview(authorNameLabel)
        
        authorNameLabel.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: componentMargin)
        authorNameLabel.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: componentMargin)
        authorNameLabel.autoPinEdge(ALEdge.Bottom, toEdge: ALEdge.Top, ofView: titleLabel, withOffset: -componentMargin / 2)
    }
}
