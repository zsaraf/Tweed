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

protocol ViewProfileAlertViewControllerDelegate: class {
    func profileAlertViewControllerDidTapCreateConversation(controller: ViewProfileAlertViewController)
    func profileAlertViewControllerDidTapDirectRequest(controller: ViewProfileAlertViewController)
}

class ViewProfileAlertViewController: SeshAlertViewController {
    // Data
    let user: User

    // Views
    let imageWrapperView = UIView()
    let imageView = UIImageView()
    let topView = UIView()
    let customView = UIView(frame: CGRectZero)

    var contentViewTopConstraint: Constraint?

    weak var viewProfileDelegate: ViewProfileAlertViewControllerDelegate?

    struct Constants {
        static let LabelHorizontalWidthProportion = 0.8
        static let GradientHeight = CGFloat(20.0)
    }

    init(user: User) {
        self.user = user
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

        self.maskImageView()
        self.updateContentViewTopConstraint()
    }

    func maskImageView() {
        self.imageWrapperView.layer.cornerRadius = self.imageWrapperView.bounds.size.width/2.0
        self.imageView.layer.cornerRadius = self.imageView.bounds.size.width/2.0
    }

    func updateContentViewTopConstraint() {
        let convertedPoint = self.topView.convertPoint(CGPointMake(0, self.topView.bounds.size.height), toView:self.view)
        self.contentViewTopConstraint?.updateOffset(convertedPoint.y + 15)
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
            make.width.equalTo(self.topView).multipliedBy(0.5)
            make.height.equalTo(self.imageWrapperView.snp_width)
        }

        let displayName = user.displayName()
        let titleLabel = UILabel(font: UIFont.SFRegular(18.0)!, textColor: UIColor.tweedBlue(), text: displayName, textAlignment: .Center)
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

        imageView.layer.masksToBounds = true
        imageView.sd_setImageWithURL(NSURL(string: self.user.profileImageUrl!))
        self.imageWrapperView.addSubview(imageView)

        imageView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.imageWrapperView)
        }
    }

    func setupCoverImageView() {
        let coverImageView = UIImageView()
        coverImageView.contentMode = .ScaleAspectFill
        coverImageView.sd_setImageWithURL(self.user.)
    }

    // MARK: Custom view setup

    func setupCustomView() {
        // We create a content view because we will want to put vertical padding on the customView
        let customContentView = self.setupCustomContentView()
        self.customView.addSubview(customContentView)

        customContentView.snp_makeConstraints { (make) -> Void in
            make.left.right.bottom.equalTo(self.customView)
            self.contentViewTopConstraint = make.top.equalTo(self.customView).constraint
        }
    }

    func setupCustomContentView() -> UIView {
        let customContentView = UIView()


        return customContentView
    }

//    func setupContentHorizontalScrollViewFirstPage() -> UIView {
//        let firstPage = UIScrollView(frame: CGRectZero)
//        firstPage.showsHorizontalScrollIndicator = false
//        firstPage.showsVerticalScrollIndicator = false
//
//        let contentView = UIView(frame: CGRectZero)
//        firstPage.addSubview(contentView)
//
//        /* Setup auto fitting scroll view */
//        contentView.snp_makeConstraints { (make) -> Void in
//            make.edges.equalTo(firstPage)
//            make.width.equalTo(firstPage)
//        }
//
//        let labelHeight = SeshInformationLabel.typicalSizeForBoundingSize(self.view.bounds.size).height
//
//        let major = self.user.major != nil && self.user.major!?.isEmpty != true ? self.user.major! : "Unspecified"
//        let majorLabel = SeshInformationLabel(frame: CGRectZero, item: SeshInformationLabelItem(text: major, imageName: "book"))
//        contentView.addSubview(majorLabel)
//
//        let classYear = self.user.class_year as? Int
//        let classYearString = classYear != nil ? "\(classYear!)" : "Unspecified"
//        let classYearLabel = SeshInformationLabel(frame: CGRectZero, item: SeshInformationLabelItem(text: classYearString, imageName: "hashtag"))
//        contentView.addSubview(classYearLabel)
//
//        let bio = (self.user.bio! == nil || self.user.bio!!.isEmpty) ? "No bio" : self.user.bio!!
//        let bioTextView = UITextView(frame: CGRectZero, textContainer: nil)
//        bioTextView.textAlignment = .Center
//        bioTextView.scrollEnabled = false
//        bioTextView.font = UIFont.bookGothamWithSize(classYearLabel.font.pointSize)
//        bioTextView.textColor = classYearLabel.textColor
//        bioTextView.text = bio
//        bioTextView.editable = false
//        contentView.addSubview(bioTextView)
//
//        majorLabel.snp_makeConstraints { (make) -> Void in
//            make.width.equalTo(firstPage).multipliedBy(Constants.LabelHorizontalWidthProportion)
//            make.height.equalTo(labelHeight)
//            make.centerX.equalTo(contentView)
//            make.top.equalTo(contentView).inset(Constants.GradientHeight)
//        }
//
//        classYearLabel.snp_makeConstraints { (make) -> Void in
//            make.width.equalTo(firstPage).multipliedBy(Constants.LabelHorizontalWidthProportion)
//            make.height.equalTo(labelHeight)
//            make.top.equalTo(majorLabel.snp_bottom)
//            make.centerX.equalTo(contentView)
//        }
//        
//        bioTextView.snp_makeConstraints { (make) -> Void in
//            make.top.equalTo(classYearLabel.snp_bottom).offset(10)
//            make.centerX.equalTo(contentView)
//            make.bottom.equalTo(contentView).inset(Constants.GradientHeight)
//            make.width.equalTo(firstPage).multipliedBy(Constants.LabelHorizontalWidthProportion)
//        }
//
//        return firstPage
//    }

//    func setupContentHorizontalScrollViewSecondPage() -> UIView {
//        let secondPage = ViewProfileClassesView(userId: self.user.user_id! as! Int, isTutor: self.user.is_tutor! as! Bool)
//        return secondPage
//    }

    // MARK: Action methods

    func tapped(button: UIButton) {
//        if user.is_tutor as! Bool {
//            self.viewProfileDelegate?.profileAlertViewControllerDidTapDirectRequest(self)
//        } else {
//            self.viewProfileDelegate?.profileAlertViewControllerDidTapCreateConversation(self)
//        }
    }

}
