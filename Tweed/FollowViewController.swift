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

class FollowViewController: UIViewController, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    let blurredImage: UIImage
    var topBarView: UIView!
    var contentView: UIView!
    var textField: TweedTextField!
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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupBackgroundView()
        self.setupTopBarView()
        self.setupContentView()
    }

    // MARK: View Setup

    func setupTopBarView() {
        self.topBarView = UIView()

        let titleLabel = UILabel(font: UIFont.mediumGotham(18.0)!, textColor: UIColor.whiteColor(), text: "Follow", textAlignment: .Center)
        titleLabel.shadowColor = UIColor(white: 0.0, alpha: 0.8)
        titleLabel.shadowOffset = CGSizeMake(0, 1)
        self.topBarView.addSubview(titleLabel)

        let cancelButton = self.topBarButton(UIImage(named: "cancel_circle")!, action: "cancel:")
        self.topBarView.addSubview(cancelButton)

        let acceptButton = self.topBarButton(UIImage(named: "check_circle")!, action: "accept:")
        self.topBarView.addSubview(acceptButton)

        titleLabel.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.topBarView)
        }

        cancelButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.topBarView).inset(20.0)
            make.height.equalTo(self.topBarView).multipliedBy(0.8)
            make.centerY.equalTo(self.topBarView)
        }

        acceptButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(self.topBarView).inset(20.0)
            make.height.equalTo(self.topBarView).multipliedBy(0.8)
            make.centerY.equalTo(self.topBarView)
        }

        self.view.addSubview(self.topBarView)

        self.topBarView.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(44.0)
            make.left.right.equalTo(self.view)
            self.topBarViewTopConstraint = make.top.equalTo(self.view).offset(UIApplication.sharedApplication().statusBarFrame.size.height).constraint
        }
    }

    func topBarButton(image: UIImage, action: String) -> UIButton {
        let btn = UIButton(type: .Custom)
        btn.setImage(UIImage(named: "check_circle"), forState: .Normal)
        btn.addTarget(self, action: "accept:", forControlEvents: .TouchUpInside)
        btn.layer.shadowColor = UIColor(white: 0, alpha: 0.1).CGColor
        btn.layer.shadowOffset = CGSizeMake(0, 1)
        btn.layer.shadowRadius = 2.0
        return btn
    }

    func setupContentView() {
        self.contentView = UIView()

        self.textField = TweedTextField(frame: CGRectZero, icon: UIImage(named: "email_gray")!)
        self.textField.returnKeyType = .Done
        self.textField.autocapitalizationType = .None
        self.textField.autocorrectionType = .No
        self.contentView.addSubview(self.textField)

        self.textField.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.contentView).offset(20.0)
            make.centerX.equalTo(self.contentView)
        }

        self.view.addSubview(self.contentView)

        self.contentView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.topBarView.snp_bottom)
            make.bottom.right.equalTo(self.view)
            self.contentViewLeftConstraint = make.left.equalTo(self.view).constraint
        }
    }

    func setupBackgroundView() {
        let blurredImageView = UIImageView(image: self.blurredImage)
        self.view.addSubview(blurredImageView)

        let tweedPatternView = UIView()
        tweedPatternView.alpha = 0.4
        tweedPatternView.backgroundColor = UIColor(patternImage: UIImage(named: "tweed_texture")!)
        self.view.addSubview(tweedPatternView)

        blurredImageView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }

        tweedPatternView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }

    // MARK: Action Methods

    func cancel(button: UIButton) {
        self.delegate?.followViewControllerDidCancel(self)
    }

    func accept(button: UIButton) {
        let animationView = SeshConfirmationAnimationView(frame: self.view.bounds)
        animationView.alpha = 0.0;
        animationView.confirmationText = "Added Followers!"
        self.view.addSubview(animationView)

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

}
