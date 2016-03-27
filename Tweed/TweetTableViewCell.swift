//
//  TweetTableViewCell.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/25/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    struct Constants {
        static let TopPadding = 10.0
        static let BottomPadding = 10.0
    }

    var profileImageView = UIImageView.init()
    var nameLabel = UILabel(font: UIFont.bookGotham(12.0)!, textColor: UIColor.tweedDarkGray(), text: "", textAlignment: .Center)
    var handleLabel = UILabel(font: UIFont.bookGotham(12.0)!, textColor: UIColor.tweedDarkGray(), text: "", textAlignment: .Center)
    var dateLabel = UILabel(font: UIFont.bookGotham(11.0)!, textColor: UIColor.tweedLightGray(), text: "", textAlignment: .Center)
    var messageTextView = UITextView(frame: CGRectZero, textContainer: nil)

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

        self.contentView.addSubview(leftWrapperView)
        self.contentView.addSubview(rightWrapperView)

        // Make constraints
        leftWrapperView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(self.contentView).multipliedBy(TweedViewConstants.CellLeftContentInsetMultiplier)
            make.left.equalTo(self.contentView)
            make.top.equalTo(self.contentView).inset(Constants.TopPadding)
        }

        rightWrapperView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(leftWrapperView.snp_right)
            make.right.equalTo(self.contentView)
            make.top.equalTo(self.contentView).inset(Constants.TopPadding)
            make.bottom.equalTo(self.contentView).inset(Constants.BottomPadding)
        }
    }

    func createLeftWrapperView() -> UIView {
        let leftWrapperView = UIView()
        leftWrapperView.addSubview(profileImageView)

        // Necessary for corner radius
        profileImageView.clipsToBounds = true

        // Make constraints
        profileImageView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(leftWrapperView.snp_width).multipliedBy(0.8)
            make.height.equalTo(profileImageView.snp_width)
            make.top.bottom.equalTo(leftWrapperView).inset(1.5)
            make.centerX.equalTo(leftWrapperView)
        }

        return leftWrapperView
    }

    func createRightWrapperView() -> UIView {
        let rightWrapperView = UIView(frame: CGRectZero)

        let nameAndTimeView = createNameAndTimeView()
        rightWrapperView.addSubview(nameAndTimeView)

        messageTextView.scrollEnabled = false
        messageTextView.font = UIFont.bookGotham(12.0)
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
            make.top.equalTo(nameAndTimeView.snp_bottom)
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
            make.top.equalTo(nameAndTimeView)
            make.left.equalTo(nameLabel.snp_right).offset(5)
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
