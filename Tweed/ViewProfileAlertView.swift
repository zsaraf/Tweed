//
//  ViewProfileAlertView.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/27/16.
//  Copyright © 2016 Zachary Waleed Saraf. All rights reserved.
//

import UIKit

@objc protocol ViewProfileAlertViewDelegate: class {
    func viewProfileAlertViewDidTapUnfollow(alertView: ViewProfileAlertView)
}

class ViewProfileAlertView: SeshAlertView, ViewProfileAlertViewControllerDelegate {
    var user: User?
    weak var viewProfileDelegate: ViewProfileAlertViewDelegate?

    init(user: User) {
        let alertViewController = ViewProfileAlertViewController(user: user)

        super.init(fromWindow: UIApplication.sharedApplication().keyWindow, customAlertViewController: alertViewController, xProportion: 0.9, yProportion: 0.6)

        self.user = user

        alertViewController.viewProfileDelegate = self

        self.dismissOnTapOutsideBounds = true
    }

    override init!(mainViewController: UIViewController!, pageTitle: String!, showCloseButton: Bool, showAcceptButton: Bool, fullScreen: Bool) {
        super.init(mainViewController: mainViewController, pageTitle: pageTitle, showCloseButton: showCloseButton, showAcceptButton: showAcceptButton, fullScreen: fullScreen)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: ViewProfileAlertViewControllerDelegate methods

    func profileAlertViewControllerDidUnfollow(alertViewController: ViewProfileAlertViewController) {
        self.viewProfileDelegate?.viewProfileAlertViewDidTapUnfollow(self)
    }

}
