//
//  FollowViewController.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/26/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import UIKit
import SnapKit

protocol FollowViewControllerDelegate: class {
    func followViewControllerDidFinish(fvc: FollowViewController)
    func followViewControllerDidCancel(fvc: FollowViewController)
}

class FollowViewController: UIViewController, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    struct FollowViewConstants {
        static let RecommendationsHeightPercent = 0.175
    }
    
    let blurredImage: UIImage

    // Top bar view
    var topBarView: UIView!
    var acceptButton: UIButton!

    // Content view
    var contentView: UIView!
    
    var textField: TweedTextField!
    var errorLabel: UILabel!
    var tableView: UITableView!

    // Data
    var addedHandles = Set<String>()
    var reccomendationsView: RecommendationsView!
    var delegate: FollowViewControllerDelegate?

    // Constraints
    var topBarViewTopConstraint: Constraint?
    var contentViewLeftConstraint: Constraint?

    init(blurredImage: UIImage) {
        self.blurredImage = blurredImage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupBackgroundView()
        self.setupTopBarView()
        self.setupContentView()
        
        User.refreshRecommendedUsers {
            self.reccomendationsView.recommendations = User.getRecommendedUsers()!
        }

    }

    // MARK: View Setup

    func setupTopBarView() {
        self.topBarView = UIView()

        let titleLabel = UILabel(font: UIFont.SFMedium(18.0)!, textColor: UIColor.whiteColor(), text: "Follow", textAlignment: .Center)
        titleLabel.shadowColor = UIColor(white: 0.0, alpha: 0.8)
        titleLabel.shadowOffset = CGSizeMake(0, 1)
        self.topBarView.addSubview(titleLabel)

        let cancelButton = self.topBarButton(UIImage(named: "cancel_circle")!, action: "cancel:")
        cancelButton.layer.shadowColor = UIColor.blackColor().CGColor
        cancelButton.layer.shadowOpacity = 0.8
        cancelButton.layer.shadowOffset = CGSizeMake(0, 1)
        cancelButton.layer.shadowRadius = 0.3

        self.topBarView.addSubview(cancelButton)

        self.acceptButton = self.topBarButton(UIImage(named: "check_circle")!, action: "accept:")
        self.acceptButton.alpha = 0.0
        self.acceptButton.layer.shadowColor = UIColor.blackColor().CGColor
        self.acceptButton.layer.shadowOpacity = 0.8
        self.acceptButton.layer.shadowOffset = CGSizeMake(0, 1)
        self.acceptButton.layer.shadowRadius = 0.3
        self.topBarView.addSubview(self.acceptButton)

        titleLabel.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.topBarView)
        }

        cancelButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.topBarView).inset(20.0)
            make.height.width.equalTo(self.topBarView.snp_height).multipliedBy(0.6)
            make.centerY.equalTo(self.topBarView)
        }

        self.acceptButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(self.topBarView).inset(20.0)
            make.height.width.equalTo(self.topBarView.snp_height).multipliedBy(0.6)
            make.centerY.equalTo(self.topBarView)
        }

        self.view.addSubview(self.topBarView)

        self.topBarView.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(44.0)
            make.left.right.equalTo(self.view)
            self.topBarViewTopConstraint = make.top.equalTo(self.view).offset(UIApplication.sharedApplication().statusBarFrame.size.height).constraint
        }
    }

    func topBarButton(image: UIImage, action: Selector) -> UIButton {
        let btn = UIButton(type: .Custom)
        btn.setImage(image, forState: .Normal)
        btn.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        btn.layer.shadowColor = UIColor(white: 0, alpha: 0.1).CGColor
        btn.layer.shadowOffset = CGSizeMake(0, 1)
        btn.layer.shadowRadius = 2.0
        return btn
    }

    func setupContentView() {
        self.contentView = UIView()
        self.view.addSubview(self.contentView)

        self.setupTextField()
        self.setupRecentlyAddedTableView()

        self.contentView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.topBarView.snp_bottom)
            make.bottom.right.equalTo(self.view)
            self.contentViewLeftConstraint = make.left.equalTo(self.view).constraint
        }
    }

    func setupTextField() {
        
        self.reccomendationsView = RecommendationsView(recommendations: User.getRecommendedUsers()!, dataSource: self)
        self.contentView.addSubview(self.reccomendationsView)
        self.reccomendationsView.snp_makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(20)
            make.left.right.equalTo(self.contentView)
            make.height.equalTo(UIScreen.mainScreen().bounds.size.height * CGFloat(FollowViewConstants.RecommendationsHeightPercent));
        }
        
        self.textField = TweedTextField(frame: CGRectZero, icon: UIImage(named: "email_gray")!)
        self.textField.delegate = self
        self.textField.returnKeyType = .Done
        self.textField.autocapitalizationType = .None
        self.textField.autocorrectionType = .No
        self.contentView.addSubview(self.textField)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidChange:", name: "UITextFieldTextDidChangeNotification", object: self.textField)

        self.errorLabel = UILabel(font: UIFont.SFRegular(14.0)!, textColor: UIColor.whiteColor(), text: "User not found", textAlignment: .Center)
        self.errorLabel.alpha = 0.0
        self.contentView.addSubview(self.errorLabel)

        self.textField.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.reccomendationsView.snp_bottom).offset(20.0)
            make.centerX.equalTo(self.contentView)
        }

        self.errorLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.textField.snp_bottom).offset(10)
            make.left.right.equalTo(self.contentView)
        }
    }

    func setupRecentlyAddedTableView() {
        self.tableView = UITableView()
        self.tableView.estimatedRowHeight = 30.0
        self.tableView.estimatedSectionHeaderHeight = 30.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.alpha = 0.0
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.contentView.addSubview(self.tableView)
        
        // To get rid of sticky section headers
        let dummyViewHeight: CGFloat = 40.0;
        let dummyView = UIView(frame: CGRect(x: 0, y: 0, width: Int(self.tableView.bounds.size.width), height: Int(dummyViewHeight)))
        self.tableView.tableHeaderView = dummyView;
        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)

        self.tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.errorLabel.snp_bottom).offset(10)
            make.bottom.left.right.equalTo(self.contentView)
        }
    }

    func setupBackgroundView() {
        let blurredImageView = UIImageView(image: self.blurredImage)
        self.view.addSubview(blurredImageView)

        blurredImageView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }

    // MARK: UITableViewDelegate/DataSource Methods

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "AddedTwitterHandleCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? AddedHandleTableViewCell
        if cell == nil {
            cell = AddedHandleTableViewCell(style: .Default, reuseIdentifier: identifier)
        }

        let handle = Array(self.addedHandles)[indexPath.row]
        cell?.addedHandleLabel.text = handle

        return cell!
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(font: UIFont.SFMedium(17.0)!, textColor: UIColor.whiteColor(), text: "Pending Follows:", textAlignment: .Center)
        label.backgroundColor = UIColor.clearColor()

        return label
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addedHandles.count
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    // MARK: Action Methods

    func cancel(button: UIButton) {
        if self.addedHandles.count > 0 {
            let alertView = SeshAlertView(swiftWithTitle: "Are you sure?", message: "You need to click the accept button in order to save these changes!", delegate: nil, cancelButtonTitle: "No", otherButtonTitles: ["Yes, I'm sure"])
            alertView.dismissalBlock = { (alertView: SeshAlertView!, index: Int) -> Void in
                if index == 0 {
                    self.delegate?.followViewControllerDidCancel(self)
                }
            }
            alertView.show()
        } else {
            self.delegate?.followViewControllerDidCancel(self)
        }

    }

    func accept(button: UIButton) {
        self.textField.resignFirstResponder()
        let animationView = SeshConfirmationAnimationView(frame: self.view.bounds)
        animationView.alpha = 0.0;
        animationView.confirmationText = "Added Followers!"
        self.view.addSubview(animationView)

        UIView.animateWithDuration(0.3) { () -> Void in
            animationView.alpha = 1.0
        }

        TweedNetworking.editHandles(Array(self.addedHandles), deletions: Array(), successHandler: { (task, responseObject) -> Void in
            for ro in responseObject as! [[String: AnyObject]] {
                let user = User.createOrUpdateUserWithObject(ro)
                user?.isFollowing = NSNumber(bool: true)
            }
            DataManager.sharedInstance().saveContext(nil)
            animationView.completionBlock = { (Void) -> Void in
                self.delegate?.followViewControllerDidFinish(self)
            }
            animationView.startAnimating()
        }) { (task, error) -> Void in
            SeshAlertView.init(swiftWithTitle: "Error!", message: "We couldn't add your handles! Please check your internet connection and try again!", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: ["Okay"]).show()

            UIView.animateWithDuration(0.3, animations: { () -> Void in
                animationView.alpha = 0.0
            }, completion: { (success: Bool) -> Void in
                animationView.removeFromSuperview()
            })
        }
    }

    // MARK: Notification observers

    func textFieldDidChange(notification: NSNotification) {
        // Remove error label
        self.errorLabel.alpha = 0.0

        if self.textField.text?.characters.count != 0 {
            self.textField.accessoryType = .ActivityIndicator
            TweedNetworking.checkHandle(self.textField.text!, successHandler: { (task, responseObject) -> Void in
                self.textField.accessoryType = .Check
                }) { (task, error) -> Void in
                    self.textField.accessoryType = .X
            }
        } else {
            self.textField.accessoryType = .None
        }
    }

    // MARK: UIViewControllerAnimatedTransitioning

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)

        if toVC is FollowViewController {
            let fvc = toVC as! FollowViewController

            self.topBarViewTopConstraint?.updateOffset(-1 * self.topBarView.bounds.size.height)
            self.contentViewLeftConstraint?.updateOffset(-1 * self.view.bounds.size.width)
            self.view.layoutIfNeeded()

            fvc.view.alpha = 0.0
            transitionContext.containerView()?.addSubview(fvc.view)
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                fvc.view.alpha = 1.0
            }, completion: { (success: Bool) -> Void in
                transitionContext.completeTransition(true)
            })

            self.topBarViewTopConstraint?.updateOffset(UIApplication.sharedApplication().statusBarFrame.size.height)
            self.contentViewLeftConstraint?.updateOffset(0)
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.4, options: UIViewAnimationOptions(), animations: { () -> Void in
                self.view.layoutIfNeeded()
            }, completion: { (success: Bool) -> Void in
                self.textField.becomeFirstResponder()
            })
        } else {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                fromVC?.view.alpha = 0.0
            }, completion: { (success: Bool) -> Void in
                transitionContext.completeTransition(true)
            })
        }
    }

    // MARK: UITextFieldDelegate Methods

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self.textField) {
            if self.textField.accessoryType == .Check {
                self.acceptButton.alpha = 1.0

                self.addScreenName(self.textField.text!)

                self.textField.text = ""

            } else if self.textField.accessoryType == .X {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.errorLabel.alpha = 1.0
                })
            }
        }

        return false
    }
    
    func addScreenName(screenName: String) {
        if (!self.addedHandles.contains(screenName)) {
            self.addedHandles.insert(screenName)
        }
        self.checkTopBar()
    }
    
    func removeScreenName(screenName: String) {
        if (self.addedHandles.contains(screenName)) {
            self.addedHandles.remove(screenName)
        }
        self.checkTopBar()
    }
    
    func checkTopBar() {
        self.tableView.reloadData()
        self.reccomendationsView.collectionView.reloadData()

        if (self.addedHandles.count > 0) {
            self.acceptButton.alpha = 1.0
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.tableView.alpha = 1.0
            })
        } else {
            self.acceptButton.alpha = 0.0
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.tableView.alpha = 0.0
            })
        }
    }

}
