//
//  LoadingViewController.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/26/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController, FollowViewControllerDelegate {
    var loadingLabel: UILabel!
    var logoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageView = UIImageView(image: UIImage(named: "tweed_loading"))
        self.view.addSubview(imageView)

        self.loadingLabel = UILabel(font: UIFont.SFMedium(16.0)!, textColor: UIColor.whiteColor(), text: "loading...", textAlignment: .Center)
        self.view.addSubview(self.loadingLabel)

        self.logoImageView = UIImageView(image: UIImage(named: "logo"))
        self.logoImageView.layer.masksToBounds = true
        self.logoImageView.contentMode = .ScaleAspectFit
        self.view.addSubview(self.logoImageView)

        imageView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }

        self.loadingLabel.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(UIScreen.mainScreen().bounds.size.height * 0.9)
        }

        self.logoImageView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.width.equalTo(self.view).dividedBy(2.0)
            make.height.equalTo(self.view.snp_width).dividedBy(2.0)
            make.top.equalTo(self.view).offset(UIScreen.mainScreen().bounds.size.height * 0.285)
        }

        if TweedAuthManager.sharedManager().isValidSession() == false {
            (UIApplication.sharedApplication().delegate as! AppDelegate).getAccessTokenWithCompletionHandler({ () -> Void in
                self.presentOnboardingViewController()
            })
        } else {
            if User.getFollowingUsers()?.count > 0 {
                Tweet.refreshTweets({ (success) -> Void in
                    let nvc = UINavigationController(rootViewController: HomeViewController())
                    self.presentViewController(nvc, animated: true, completion: nil)
                })
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if User.getFollowingUsers()?.count == 0 {
            self.presentOnboardingViewController()
        }
    }

    func presentOnboardingViewController() {
        let blurredImage = UIImage.blurredImageWithRootView(self.view, tintColor: UIColor(white: 0, alpha: 0.3), radius: 12, saturationDeltaFactor: 1.1)
        let fvc = OnboardingViewController(blurredImage: blurredImage)
        fvc.delegate = self
        fvc.modalPresentationStyle = .Custom
        fvc.transitioningDelegate = fvc
        self.presentViewController(fvc, animated: true) { () -> Void in
            fvc.transitioningDelegate = nil
        }
    }

    // MARK: FollowViewControllerDelegate methods

    func followViewControllerDidCancel(fvc: FollowViewController) {
        assertionFailure()
    }

    func followViewControllerDidFinish(fvc: FollowViewController) {
        fvc.transitioningDelegate = fvc
        self.dismissViewControllerAnimated(true) { () -> Void in
            let av = SeshAlertView(swiftWithTitle: "You're Set!", message: "We hope that GoFundMe enjoys the Tweed experience!", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: ["CHEERS!"])
            av.show()

            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                let nvc = UINavigationController(rootViewController: HomeViewController())
                self.presentViewController(nvc, animated: false, completion: nil)
            }
        }

    }

}
