//
//  ViewProfileAlertViewController.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/27/16.
//  Copyright © 2016 Zachary Waleed Saraf. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit
import HexColors

protocol ViewProfileAlertViewControllerDelegate: class {
    func profileAlertViewControllerDidUnfollow(alertViewController: ViewProfileAlertViewController)
}

class ViewProfileAlertViewController: SeshAlertViewController {
    // Data
    let user: User
    let hidesFollowButton: Bool

    // Views
    let imageWrapperView = UIView()
    let imageView = UIImageView()
    let topView = UIView()
    let customView = UIView(frame: CGRectZero)

    var contentViewTopConstraint: Constraint?
    var coverImageViewBottomConstraint: Constraint?

    weak var viewProfileDelegate: ViewProfileAlertViewControllerDelegate?

    struct Constants {
        static let HorizontalInset = 20.0
        static let FontSize = CGFloat(17.0)
    }

    init(user: User, hidesFollowButton: Bool) {
        self.user = user
        self.hidesFollowButton = hidesFollowButton
        super.init(title: "", buttonItems: [], customView: customView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupCustomView()
        self.setupTopView()
    }

    // MARK: Layout subview helper methods

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.updateContentViewTopConstraint()
    }

    func updateContentViewTopConstraint() {
        let convertedPoint = self.topView.convertPoint(CGPointMake(0, self.topView.bounds.size.height), toView:self.view)
        self.coverImageViewBottomConstraint?.updateOffset(convertedPoint.y + 15)
    }

    // MARK: Top view setup

    func setupTopView() {
        self.topView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.topView)

        self.setupImageView()
        self.topView.addSubview(self.imageWrapperView)

        self.topView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(-40.0)
            make.left.right.equalTo(self.view)
        }

        self.imageWrapperView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.topView)
            make.centerX.equalTo(self.topView)
            make.width.equalTo(self.topView).multipliedBy(0.4)
            make.height.equalTo(self.imageWrapperView.snp_width)
        }

        let displayName = user.displayName()
        let titleLabel = UILabel(font: UIFont.SFRegular(26.0)!, textColor: UIColor.whiteColor(), text: displayName, textAlignment: .Center)
        titleLabel.shadowColor = UIColor(white: 0, alpha: 0.4)
        titleLabel.shadowOffset = CGSizeMake(0, 1)
        titleLabel.layer.shadowRadius = 4.0
        self.topView.addSubview(titleLabel)

        titleLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.topView)
            make.top.equalTo(self.imageWrapperView.snp_bottom).offset(10)
            make.bottom.equalTo(self.topView)
        }
    }

    func setupImageView() {
        self.imageWrapperView.layer.masksToBounds = false
        self.imageWrapperView.layer.shadowColor = UIColor.blackColor().CGColor;
        self.imageWrapperView.layer.shadowOffset = CGSizeMake(0, 0);
        self.imageWrapperView.layer.shadowOpacity = 0.4;
        self.imageWrapperView.layer.shadowRadius = 3;
        self.imageWrapperView.layer.cornerRadius = 5.0

        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5.0
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.layer.borderWidth = 2.0
        imageView.sd_setImageWithURL(NSURL(string: self.user.bigProfileImageUrl()))
        self.imageWrapperView.addSubview(imageView)

        imageView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.imageWrapperView)
        }
    }

    func setupCoverImageView() -> UIImageView {
        let coverImageView = UIImageView()
        coverImageView.contentMode = .ScaleAspectFill
        coverImageView.clipsToBounds = true

        if self.user.profileBackgroundColor != nil {
            coverImageView.backgroundColor = UIColor.hx_colorWithHexRGBAString("#\(self.user.profileBackgroundColor!)")
        }

        if self.user.profileBannerImageUrl != nil {
            SDWebImageManager.sharedManager().downloadImageWithURL(NSURL(string: self.user.profileBannerImageUrl!), options: SDWebImageOptions(), progress: nil) { (image: UIImage!, error: NSError!, type: SDImageCacheType, finished: Bool, url: NSURL!) -> Void in
                let blurredImage = image.applyBlurWithRadius(10.0, tintColor: UIColor(white: 0, alpha: 0.2), saturationDeltaFactor: 1.2, maskImage: nil)
                coverImageView.image = blurredImage
            }
        }
        return coverImageView
    }

    // MARK: Custom view setup

    func setupCustomView() {
        // We create a content view because we will want to put vertical padding on the customView
        let customContentView = self.setupCustomContentView()
        self.customView.addSubview(customContentView)

        customContentView.snp_makeConstraints { (make) -> Void in
            make.left.right.bottom.equalTo(self.customView)
            self.contentViewTopConstraint = make.top.equalTo(self.view).constraint
        }
    }

    func setupCustomContentView() -> UIView {
        let customContentView = UIView()

        // Add subviews
        let coverImageView = self.setupCoverImageView()
        customContentView.addSubview(coverImageView)

        let handleLabel = UILabel(font: UIFont.SFRegular(Constants.FontSize)!, textColor: UIColor.tweedGray(), text: "@\(self.user.screenName!)", textAlignment: .Left)
        customContentView.addSubview(handleLabel)

        let dotView = SeshDotView(frame: CGRectZero)
        customContentView.addSubview(dotView)

        let locationLabel = UILabel(font: UIFont.SFRegular(Constants.FontSize)!, textColor: UIColor.tweedGray(), text: self.user.location!, textAlignment: .Left)
        customContentView.addSubview(locationLabel)

        let bioLabel = UILabel(font: UIFont.SFRegular(Constants.FontSize)!, textColor: UIColor.tweedGray(), text: self.user.bio!, textAlignment: .Left)
        bioLabel.numberOfLines = 0
        bioLabel.lineBreakMode = .ByWordWrapping
        customContentView.addSubview(bioLabel)

        let countsViewWrapper = UIView()
        customContentView.addSubview(countsViewWrapper)

        let countsView = self.setupProfileCountsView()
        countsViewWrapper.addSubview(countsView)

        let unfollowButton = TweedBorderedButton(type: .Gray)
        unfollowButton.setTitle("Unfollow", forState: .Normal)
        unfollowButton.addTarget(self, action: "unfollow:", forControlEvents: .TouchUpInside)
        customContentView.addSubview(unfollowButton)
        
        // Setup constraints

        coverImageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(customContentView)
            make.left.right.equalTo(customContentView)
            self.coverImageViewBottomConstraint = make.bottom.equalTo(customContentView.snp_top).constraint
        }

        handleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(coverImageView.snp_bottom).offset(Constants.HorizontalInset)
            make.left.equalTo(customContentView).offset(Constants.HorizontalInset)
        }

        dotView.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(3.0)
            make.left.equalTo(handleLabel.snp_right).offset(5)
            make.centerY.equalTo(handleLabel)
        }

        locationLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(handleLabel)
            make.left.equalTo(dotView.snp_right).offset(5)
        }

        bioLabel.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(customContentView).inset(Constants.HorizontalInset)
            make.top.equalTo(handleLabel.snp_bottom).offset(10)
        }

        
        countsViewWrapper.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(customContentView)
            make.top.equalTo(bioLabel.snp_bottom)
            make.bottom.equalTo(unfollowButton.snp_top)
        }

        countsView.snp_makeConstraints { (make) -> Void in
            make.left.right.centerY.equalTo(countsViewWrapper)
        }

        unfollowButton.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(customContentView).inset(Constants.HorizontalInset)
            make.centerX.equalTo(customContentView)
        }
        
        if (self.hidesFollowButton) {
            countsViewWrapper.snp_updateConstraints(closure: { (make) in
                make.bottom.equalTo(customContentView).inset(Constants.HorizontalInset)
            })
            unfollowButton.hidden = true
        }

        return customContentView
    }

    func setupProfileCountsView() -> UIView {
        let countsView = UIView()

        let tweetCountView = self.setupProfileCountView(self.user.tweetCount!.abbreviated(), explanation: "Tweets")
        countsView.addSubview(tweetCountView)

        let followingCountView = self.setupProfileCountView(self.user.followingCount!.abbreviated(), explanation: "Following")
        countsView.addSubview(followingCountView)

        let followerCountView = self.setupProfileCountView(self.user.followersCount!.abbreviated(), explanation: "Followers")
        countsView.addSubview(followerCountView)

        tweetCountView.snp_makeConstraints { (make) -> Void in
            make.left.top.bottom.equalTo(countsView)
            make.width.equalTo(countsView).dividedBy(3.0)
        }

        followingCountView.snp_makeConstraints { (make) -> Void in
            make.top.bottom.equalTo(countsView)
            make.left.equalTo(tweetCountView.snp_right)
            make.width.equalTo(countsView).dividedBy(3.0)
        }

        followerCountView.snp_makeConstraints { (make) -> Void in
            make.top.bottom.right.equalTo(countsView)
            make.left.equalTo(followingCountView.snp_right)
            make.width.equalTo(countsView).dividedBy(3.0)
        }

        return countsView
    }

    func setupProfileCountView(num: String, explanation: String) -> UIView {
        let view = UIView()

        let numLabel = UILabel(font: UIFont.SFRegular(Constants.FontSize)!, textColor: UIColor.tweedGray(), text: num, textAlignment: .Center)
        view.addSubview(numLabel)

        let explanationLabel = UILabel(font: UIFont.SFRegular(Constants.FontSize - CGFloat(2.0))!, textColor: UIColor.tweedGray(), text: explanation, textAlignment: .Center)
        view.addSubview(explanationLabel)

        numLabel.snp_makeConstraints { (make) -> Void in
            make.left.right.top.equalTo(view)
        }

        explanationLabel.snp_makeConstraints { (make) -> Void in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(numLabel.snp_bottom).offset(5)
        }

        return view
    }

    // MARK: Action methods

    func unfollow(button: UIButton) {
        self.viewProfileDelegate?.profileAlertViewControllerDidUnfollow(self)
    }

}
