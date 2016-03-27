//
//  TweetTableViewCell.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/25/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import UIKit
import NSDate_TimeAgo

class TweetTableViewCell: UITableViewCell {

    struct Constants {
        static let TopPadding = 10.0
        static let BottomPadding = 10.0
    }

    private let profileImageView = UIImageView.init()
    private let nameLabel = UILabel(font: UIFont.SFMedium(17.0)!, textColor: UIColor.tweedGray(), text: "", textAlignment: .Center)
    private let handleLabel = UILabel(font: UIFont.SFRegular(14.0)!, textColor: UIColor.tweedGray(), text: "", textAlignment: .Center)
    private let dateLabel = UILabel(font: UIFont.SFRegular(12.0)!, textColor: UIColor.tweedLightGray(), text: "", textAlignment: .Center)
    private let messageTextView = UITextView(frame: CGRectZero, textContainer: nil)
    
    var tweet: Tweet? {
        didSet {
            self.messageTextView.text = (self.tweet?.text)!
            self.dateLabel.text = self.tweet?.createdAt?.timeAgo()
            self.nameLabel.text = self.tweet?.user?.displayName()
            self.handleLabel.text = "@" + (self.tweet?.user?.screenName)!
            self.profileImageView.sd_setImageWithURL(NSURL(string: (self.tweet?.user?.profileImageUrl)!))
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        // Create wrapper views
        let leftWrapperView = self.createLeftWrapperView()
        let rightWrapperView = self.createRightWrapperView()
        let dividerView = self.createDividerView()
        
        self.contentView.addSubview(leftWrapperView)
        self.contentView.addSubview(rightWrapperView)
        self.contentView.addSubview(dividerView)

        // Make constraints
        leftWrapperView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(self.contentView).multipliedBy(TweedViewConstants.CellLeftContentInsetMultiplier)
            make.top.left.equalTo(self.contentView).inset(Constants.TopPadding)
        }

        rightWrapperView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(leftWrapperView.snp_right).offset(Constants.TopPadding)
            make.right.equalTo(self.contentView)
            make.top.equalTo(self.contentView).inset(Constants.TopPadding)
            make.bottom.equalTo(dividerView.snp_top).offset(-Constants.TopPadding)
        }
        
        dividerView.snp_makeConstraints { (make) in
            make.left.equalTo(leftWrapperView.snp_right).offset(Constants.TopPadding)
            make.bottom.right.equalTo(self.contentView)
            make.height.equalTo(3 / UIScreen.mainScreen().scale)
        }
    }
    
    func createDividerView() -> UIView {
        let dividerView = UIView()
        dividerView.backgroundColor = UIColor.tweedDividerColor()
        return dividerView
    }

    func createLeftWrapperView() -> UIView {
        let leftWrapperView = UIView()

        let profileShadowView = UIView()
        profileShadowView.layer.shadowColor = UIColor.blackColor().CGColor
        profileShadowView.layer.shadowRadius = 1.0
        profileShadowView.layer.shadowOpacity = 0.5
        profileShadowView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        leftWrapperView.addSubview(profileShadowView)
        profileShadowView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(leftWrapperView.snp_width)
            make.height.equalTo(profileShadowView.snp_width)
            make.top.bottom.equalTo(leftWrapperView).inset(1.5)
            make.centerX.equalTo(leftWrapperView)
        }
        
        // Necessary for corner radius
        profileImageView.clipsToBounds = true
        profileShadowView.addSubview(profileImageView)
        profileImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(profileShadowView)
        }
        

        return leftWrapperView
    }

    func createRightWrapperView() -> UIView {
        let rightWrapperView = UIView(frame: CGRectZero)

        let nameAndTimeView = createNameAndTimeView()
        rightWrapperView.addSubview(nameAndTimeView)

        messageTextView.scrollEnabled = false
        messageTextView.font = UIFont.SFRegular(14.0)
        messageTextView.textColor = UIColor.tweedGray()
        messageTextView.editable = false
        messageTextView.contentInset = UIEdgeInsetsZero
        messageTextView.textContainer.lineFragmentPadding = 0.0
        messageTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        messageTextView.textContainer.lineBreakMode = NSLineBreakMode.ByWordWrapping
        rightWrapperView.addSubview(messageTextView)

        nameAndTimeView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(rightWrapperView)
            make.left.right.equalTo(rightWrapperView)
        }

        // Make constraints
        messageTextView.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(rightWrapperView)
            make.left.equalTo(rightWrapperView)
            make.top.equalTo(nameAndTimeView.snp_bottom).offset(Constants.TopPadding / 2)
            make.bottom.equalTo(rightWrapperView)
        }

        return rightWrapperView
    }

    func createNameAndTimeView() -> UIView {
        let nameAndTimeView = UIView(frame: CGRectZero)

        nameAndTimeView.addSubview(handleLabel)
        nameAndTimeView.addSubview(nameLabel)
        nameAndTimeView.addSubview(dateLabel)

        // Make constraints
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.top.left.bottom.equalTo(nameAndTimeView)
            make.height.equalTo((nameLabel.text! as NSString).sizeWithAttributes([NSFontAttributeName: nameLabel.font]).height)
        }

        handleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(nameAndTimeView).offset(1)
            make.left.equalTo(nameLabel.snp_right).offset(Constants.TopPadding)
        }

        dateLabel.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(nameAndTimeView).inset(10)
            make.centerY.equalTo(nameAndTimeView)
        }
        
        return nameAndTimeView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.contentView.layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width/2
    }


}
