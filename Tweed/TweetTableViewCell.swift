//
//  TweetTableViewCell.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/25/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import UIKit
import NSDate_TimeAgo
import SnapKit

protocol TweetTableViewCellDelegate: class {
    func tweetTableViewCellDidTapMedia(cell: TweetTableViewCell, media: Media)
    func tweetTableViewCellDidTapMention(cell: TweetTableViewCell, mention: Mention)
    func tweetTableViewCellDidTapUrl(cell: TweetTableViewCell, url: String)
}

class TweetTableViewCell: UITableViewCell, TweetTextViewDelegate {

    struct Constants {
        static let TopPadding = 10.0
        static let BottomPadding = 10.0
        static let RetweetPadding = 10.0
        static let ImageMaxWidth = Double(UIScreen.mainScreen().bounds.size.width) * (1 - TweedViewConstants.CellLeftContentInsetMultiplier - 0.05)
        static let ImageMaxHeight = Double(UIScreen.mainScreen().bounds.size.height)/4.0
    }

    var delegate: TweetTableViewCellDelegate?

    private let profileImageView = UIImageView.init()
    private let nameLabel = UILabel(font: UIFont.SFMedium(17.0)!, textColor: UIColor.tweedGray(), text: "", textAlignment: .Center)
    private let handleLabel = UILabel(font: UIFont.SFRegular(14.0)!, textColor: UIColor.tweedGray(), text: "", textAlignment: .Center)
    private let dateLabel = UILabel(font: UIFont.SFRegular(12.0)!, textColor: UIColor.tweedLightGray(), text: "", textAlignment: .Center)
    private let messageTextView = TweetTextView(frame: CGRectZero, textContainer: nil)
    var mediaImageView: UIImageView!

    // Constraints
    var mediaImageWidthConstraint: Constraint?
    var mediaImageHeightConstraint: Constraint?
    var mediaImageTopConstraint: Constraint?
    
    // Retweet stuff
    private let retweetedByLabel = UILabel(font: UIFont.SFRegular(12)!, textColor: UIColor.tweedGray(), text: "", textAlignment: .Center)
    private var retweetedByView: UIView!
    private var retweetedByViewTopConstraint: Constraint?
    private var heightConstraint: Constraint?
    
    var tweet: Tweet? {
        didSet {
            var t = self.tweet!
            if tweet?.originalTweet != nil {
                self.retweetedByViewTopConstraint?.updateOffset(Constants.TopPadding)
                self.heightConstraint?.uninstall()
                
                self.retweetedByLabel.text = (self.tweet?.user?.displayName())!

                t = self.tweet!.originalTweet!
            } else {
                self.heightConstraint?.uninstall()
                self.retweetedByView.snp_makeConstraints(closure: { (make) in
                    self.heightConstraint = make.height.equalTo(0).constraint
                })
                self.retweetedByViewTopConstraint?.updateOffset(0)

                self.retweetedByLabel.text = ""
            }

            self.messageTextView.tweet = t
            self.dateLabel.text = t.createdAt?.timeAgo()
            self.nameLabel.text = t.user?.displayName()
            self.handleLabel.text = "@" + (t.user?.screenName)!
            self.profileImageView.sd_setImageWithURL(NSURL(string: (t.user?.profileImageUrl)!))

            // Handle media size
            if t.media?.count > 0 {
                let media = t.media?.sort({ (media1: AnyObject, media2: AnyObject) -> Bool in
                    return ((media1 as! Media).id as! Int) < ((media2 as! Media).id as! Int)
                }).first as! Media

                let width = media.width as! Double
                let height = media.height as! Double

                let widthProportion = width / Constants.ImageMaxWidth
                let heightProportion = height / Constants.ImageMaxHeight
                let resizingProportion = max(widthProportion, heightProportion)

                let resizedSize = CGSizeMake(CGFloat(width/resizingProportion), CGFloat(height/resizingProportion))
                self.mediaImageWidthConstraint?.updateOffset(resizedSize.width)
                self.mediaImageHeightConstraint?.updateOffset(resizedSize.height)
                self.mediaImageTopConstraint?.updateOffset(Constants.TopPadding)

                self.mediaImageView.sd_setImageWithURL(NSURL(string: media.mediaUrl!))
            } else {
                self.mediaImageHeightConstraint?.updateOffset(0.0)
                self.mediaImageTopConstraint?.updateOffset(0)
            }
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
        self.retweetedByView = self.createRetweetView()
        let dividerView = self.createDividerView()
        self.mediaImageView = self.createMediaImageView()
        
        self.contentView.addSubview(leftWrapperView)
        self.contentView.addSubview(rightWrapperView)
        self.contentView.addSubview(self.retweetedByView)
        self.contentView.addSubview(self.mediaImageView)
        self.contentView.addSubview(dividerView)

        // Make constraints
        leftWrapperView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(self.contentView).multipliedBy(TweedViewConstants.CellLeftContentInsetMultiplier)
            make.top.left.equalTo(self.contentView).inset(Constants.TopPadding)
        }

        rightWrapperView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(leftWrapperView.snp_right).offset(Constants.TopPadding)
            make.right.equalTo(self.contentView).inset(Constants.TopPadding)
            make.top.equalTo(self.contentView).inset(Constants.TopPadding)
        }

        self.mediaImageView.snp_makeConstraints { (make) -> Void in
            self.mediaImageTopConstraint = make.top.equalTo(rightWrapperView.snp_bottom).offset(Constants.TopPadding).constraint
            make.centerX.equalTo(rightWrapperView)
            self.mediaImageWidthConstraint = make.width.equalTo(Constants.ImageMaxWidth).constraint
            self.mediaImageHeightConstraint = make.height.equalTo(Constants.ImageMaxHeight).constraint
        }

        self.retweetedByView.snp_makeConstraints { (make) -> Void in
            self.retweetedByViewTopConstraint = make.top.equalTo(self.mediaImageView.snp_bottom).offset(Constants.RetweetPadding).constraint
            make.right.equalTo(self.contentView)
            make.left.equalTo(rightWrapperView)
        }

        dividerView.snp_makeConstraints { (make) in
            make.left.equalTo(leftWrapperView.snp_right).offset(Constants.TopPadding)
            make.bottom.right.equalTo(self.contentView)
            make.top.equalTo(self.retweetedByView.snp_bottom).offset(Constants.RetweetPadding)
            make.height.equalTo(2 / UIScreen.mainScreen().scale)
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

        messageTextView.tweetDelegate = self
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
            make.right.equalTo(nameAndTimeView)
            make.centerY.equalTo(nameAndTimeView)
        }
        
        return nameAndTimeView
    }

    func createRetweetView() -> UIView {
        let retweetView = UIView()

        let wrapperView = UIView()
        let retweetedImage = UIImage(named: "retweet")!
        let resizedImage = UIImage(CGImage: retweetedImage.CGImage!, scale: (retweetedImage.scale * 1.75), orientation: .Up)
        let retweetedImageView = UIImageView(image: resizedImage)
        retweetedImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        wrapperView.addSubview(retweetedImageView)
        wrapperView.addSubview(self.retweetedByLabel)
        
        retweetedImageView.snp_makeConstraints { (make) in
            make.left.top.bottom.equalTo(wrapperView)
        }
        
        self.retweetedByLabel.snp_makeConstraints { (make) in
            make.top.right.bottom.equalTo(wrapperView)
            make.left.equalTo(retweetedImageView.snp_right).offset(Constants.TopPadding - 3)
        }
        
        retweetView.addSubview(wrapperView)
        wrapperView.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(retweetView)
            make.left.equalTo(retweetView)
        }
        
        return retweetView
    }

    func createMediaImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.lightGrayColor()
        imageView.contentMode = .ScaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4.0
        imageView.userInteractionEnabled = true

        let tapRecognizer = UITapGestureRecognizer(target: self, action: "mediaTapped:")
        imageView.addGestureRecognizer(tapRecognizer)
        return imageView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.contentView.layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width/2
    }

    // MARK: Action Methods

    func mediaTapped(recognizer: UITapGestureRecognizer) {
        let t = self.tweet!.originalTweet != nil ? self.tweet!.originalTweet! : self.tweet!

        let media = t.media?.sort({ (media1: AnyObject, media2: AnyObject) -> Bool in
            return ((media1 as! Media).id as! Int) < ((media2 as! Media).id as! Int)
        }).first as! Media
        self.delegate?.tweetTableViewCellDidTapMedia(self, media: media)
    }

    // MARK: TweetTextViewDelegate methods

    func tweetTextViewDidTapMedia(textView: TweetTextView, media: Media) {
        self.delegate?.tweetTableViewCellDidTapMedia(self, media: media)
    }

    func tweetTextViewDidTapMention(textView: TweetTextView, mention: Mention) {
        self.delegate?.tweetTableViewCellDidTapMention(self, mention: mention)
    }

    func tweetTextViewDidTapUrl(textView: TweetTextView, url: String) {
        self.delegate?.tweetTableViewCellDidTapUrl(self, url: url)
    }


}
