//
//  HomeViewController.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/25/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FollowViewControllerDelegate {
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()

        self.configureNavigationBar()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 60.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorInset = UIEdgeInsetsMake(0, UIScreen.mainScreen().bounds.size.width * CGFloat(TweedViewConstants.CellLeftContentInsetMultiplier), 0, 0)
        self.tableView.separatorStyle = .None
        self.tableView.allowsSelection = false
        self.view.addSubview(self.tableView)

        self.tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }

    func configureNavigationBar() {
        self.title = "Timeline"

        let addFollowsButton = UIButton(type: .Custom)
        addFollowsButton.bounds = CGRectMake(0, 0, 20, 20)
        addFollowsButton.setImage(UIImage(named: "plus_white"), forState: .Normal)
        addFollowsButton.addTarget(self, action: "addFollows:", forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addFollowsButton)
    }

    // MARK: UITableViewDelegate & UITableViewDataSource methods

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "TweedTweetCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? TweetTableViewCell
        if cell == nil {
            cell = TweetTableViewCell(style: .Default, reuseIdentifier: identifier)
            cell?.selectionStyle = .None
        }

        cell?.messageTextView.text = "Hey this is my first tweet. Feels good to be alive! Read all of my tweets. Catch up on everything."
        cell?.dateLabel.text = "4/15/15"
        cell?.nameLabel.text = "Zach S."
        cell?.handleLabel.text = "@zacharysaraf"
        cell?.profileImageView.sd_setImageWithURL(NSURL(string: "https://media.licdn.com/mpr/mpr/shrinknp_200_200/p/7/000/211/124/06ee517.jpg"))

        return cell!
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let user = User.testUser()
        let alertView = ViewProfileAlertView(user: user!)
        alertView.show()
    }

    // MARK: Action methods

    func addFollows(button: UIButton) {
        let rootView = self.navigationController!.view
        let blurredImage = UIImage.blurredImageWithRootView(rootView, tintColor: UIColor(white: 1, alpha: 0.1), radius: 6, saturationDeltaFactor: 1.2)

        let fvc = FollowViewController(blurredImage: blurredImage)
        fvc.delegate = self
        fvc.modalPresentationStyle = .Custom
        fvc.transitioningDelegate = fvc
        self.presentViewController(fvc, animated: true) { () -> Void in
            fvc.transitioningDelegate = nil
        }

    }

    // MARK: FollowViewControllerDelegate methods

    func followViewControllerDidCancel(fvc: FollowViewController) {
        fvc.transitioningDelegate = fvc
        self.dismissViewControllerAnimated(true) { () -> Void in
            fvc.transitioningDelegate = nil
        }
    }

    func followViewControllerDidFinish(fvc: FollowViewController) {
        fvc.transitioningDelegate = fvc
        self.dismissViewControllerAnimated(true) { () -> Void in
            fvc.transitioningDelegate = nil
        }
    }

}
