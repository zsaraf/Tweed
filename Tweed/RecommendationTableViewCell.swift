//
//  RecommendationTableViewCell.swift
//  Tweed
//
//  Created by Raymond Kennedy on 3/26/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit

protocol RecommendationTableViewCellDelegate: class {
    func followButtonHit(screenName: String, cell: UICollectionViewCell)
}

class RecommendationTableViewCell: UICollectionViewCell {
    
    private let avatarImageView = UIImageView()
    private let screenNameLabel = UILabel(font: UIFont.SFRegular(16)!, textColor: UIColor.tweedGray(), text: "", textAlignment: .Left)
    private let fullNameLabel = UILabel(font: UIFont.SFMedium(20)!, textColor: UIColor.tweedGray(), text: "", textAlignment: .Left)
    private let followButton = TweedBorderedButton()

    var delegate: RecommendationTableViewCellDelegate?
    
    var user: User? {
        didSet {
            
            self.screenNameLabel.text = "@" + (user?.screenName)!
            self.fullNameLabel.text = user?.displayName()
            self.avatarImageView.sd_setImageWithURL(NSURL(string: (user?.profileImageUrl)!))
            
        }
    }
    
    // MARK: Init Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup Methods
    
    func setupViews() {
        self.contentView.layer.masksToBounds = true
        
        let wrapperView = UIView()
        wrapperView.layer.cornerRadius = 6.0
        wrapperView.layer.shadowColor = UIColor.blackColor().CGColor
        wrapperView.layer.shadowRadius = 1.0
        wrapperView.layer.shadowOpacity = 0.5
        wrapperView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        
        wrapperView.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(wrapperView)
        wrapperView.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self.contentView).inset(10)
            make.left.right.equalTo(self.contentView).inset(5)
        }
        
        let leftContentView = self.setupLeftContentView()
        leftContentView.layer.shadowColor = UIColor.blackColor().CGColor
        leftContentView.layer.shadowRadius = 1.0
        leftContentView.layer.shadowOpacity = 0.5
        leftContentView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        wrapperView.addSubview(leftContentView)
        leftContentView.snp_makeConstraints { (make) in
            make.left.top.bottom.equalTo(wrapperView).inset(10)
            make.width.equalTo(leftContentView.snp_height)
        }
        
        let rightContentView = self.setupRightContentView()
        wrapperView.addSubview(rightContentView)
        rightContentView.snp_makeConstraints { (make) in
            make.left.equalTo(leftContentView.snp_right).offset(15)
            make.top.bottom.equalTo(leftContentView)
            make.right.equalTo(wrapperView).inset(15)
        }
    }
    
    func setupLeftContentView() -> UIView {
        let wrapper = UIView()
        self.avatarImageView.layer.cornerRadius = 6.0
        self.avatarImageView.layer.masksToBounds = true
        wrapper.addSubview(self.avatarImageView)
        self.avatarImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(wrapper)
        }
        return wrapper
    }
    
    func setupRightContentView() -> UIView {
        let wrapper = UIView()
        let upperSpacer = UIView()
        let lowerSpacer = UIView()
        
        wrapper.addSubview(self.fullNameLabel)
        self.fullNameLabel.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(wrapper)
        }
        
        wrapper.addSubview(upperSpacer)
        upperSpacer.snp_makeConstraints { (make) in
            make.left.right.equalTo(wrapper)
            make.top.equalTo(self.fullNameLabel.snp_bottom)
            make.height.greaterThanOrEqualTo(5)
        }
        
        wrapper.addSubview(self.screenNameLabel)
        self.screenNameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(upperSpacer.snp_bottom)
            make.left.right.equalTo(wrapper)
        }
        
        wrapper.addSubview(lowerSpacer)
        lowerSpacer.snp_makeConstraints { (make) in
            make.left.right.equalTo(wrapper)
            make.top.equalTo(self.screenNameLabel.snp_bottom)
            make.height.equalTo(upperSpacer.snp_height)
        }
        
        self.followButton.setTitle("Follow", forState: .Normal)
        self.followButton.addTarget(self, action: "followButtonHit:", forControlEvents: .TouchUpInside)
        wrapper.addSubview(self.followButton)
        let buttonSize = self.followButton.typicalSize()
        self.followButton.snp_makeConstraints { (make) in
            make.top.equalTo(lowerSpacer.snp_bottom)
            make.left.bottom.equalTo(wrapper)
            make.width.equalTo(buttonSize.width).constraint
        }
        
        return wrapper
    }
    
    func setFollowButtonTitle(title: String) {
        self.followButton.setTitle(title, forState: .Normal)
        let buttonSize = self.followButton.typicalSize()
        self.followButton.snp_updateConstraints { (make) in
            make.width.equalTo(buttonSize.width)
        }
    }
    
    // Private Methods
    
    func followButtonHit(sender: UIButton) {
        if (self.delegate != nil) {
            self.delegate?.followButtonHit((self.user?.screenName)!, cell: self)
        }
    }
    
}
