//
//  OnboardingViewController.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/27/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import UIKit

class OnboardingViewController: FollowViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Custom label text
        self.titleLabel.text = "Welcome to Tweed!"

        self.recommendationHelpLabel.text = "Follow someone to get started!"

        self.cancelButton.hidden = true
        self.cancelButton.userInteractionEnabled = false
    }

}
