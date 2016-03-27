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
import TLYShyNavBar

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, FollowViewControllerDelegate, ViewProfileAlertViewDelegate {
    let tableView = UITableView()
    var followingCollectionView: UICollectionView!

    private var tweets = Tweet.getAllTweets()
    private var following = User.getFollowingUsers()!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false

        self.setupNavigationBar()
        self.setupCollectionView()
        self.setupTableView()

        self.refreshTweets()
    }

    func setupNavigationBar() {
        self.title = "Timeline"

        let addFollowsButton = UIButton(type: .Custom)
        addFollowsButton.bounds = CGRectMake(0, 0, 20, 20)
        addFollowsButton.setImage(UIImage(named: "plus_white"), forState: .Normal)
        addFollowsButton.addTarget(self, action: "addFollows:", forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addFollowsButton)
    }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let itemSize = UIScreen.mainScreen().bounds.size.height * 0.1
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.sectionInset = UIEdgeInsetsZero

        self.followingCollectionView = UICollectionView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, itemSize), collectionViewLayout: layout)
        self.followingCollectionView.delegate = self
        self.followingCollectionView.dataSource = self
        self.followingCollectionView.showsHorizontalScrollIndicator = false
        self.followingCollectionView.showsVerticalScrollIndicator = false
        self.followingCollectionView.alwaysBounceHorizontal = true
        self.followingCollectionView.registerClass(FollowingCollectionViewCell.self, forCellWithReuseIdentifier: FollowingCollectionViewCell.Identifier)
        self.followingCollectionView.backgroundColor = UIColor.tweedBlue()

        self.shyNavBarManager.extensionView = self.followingCollectionView
    }

    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 60.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorInset = UIEdgeInsetsMake(0, UIScreen.mainScreen().bounds.size.width * CGFloat(TweedViewConstants.CellLeftContentInsetMultiplier), 0, 0)
        self.tableView.separatorStyle = .None
        self.view.addSubview(self.tableView)

        self.shyNavBarManager.scrollView = self.tableView

        self.tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }

    // MARK: UICollectionViewDataSource

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(FollowingCollectionViewCell.Identifier, forIndexPath: indexPath) as! FollowingCollectionViewCell
        let user = self.following[indexPath.row]
        cell.user = user
        return cell
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.following.count
    }

    // MARK: UITableViewDelegate & UITableViewDataSource methods

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "TweedTweetCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? TweetTableViewCell
        if cell == nil {
            cell = TweetTableViewCell(style: .Default, reuseIdentifier: identifier)
            cell?.selectionStyle = .None
        }

        cell?.tweet = self.tweets[indexPath.row]

        return cell!
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let user = self.tweets[indexPath.row].user!
        let alertView = ViewProfileAlertView(user: user)
        alertView.viewProfileDelegate = self
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
        self.refreshTweets()
    }
    
    // MARK: Private Methods

    func updateViewsWithCoreData() {
        // Assign tweets and resume operations as normal
        self.tweets = Tweet.getAllTweets()
        self.following = User.getFollowingUsers()!
        self.followingCollectionView.reloadData()
        self.tableView.reloadData()
    }

    func refreshTweets() {
        TweedNetworking.refreshTweets({ (task, responseObject) in
            
            // Get users and tweets
            let users = responseObject!["twitter_users"] as! [[String: AnyObject]]
            let tweets = responseObject!["tweets"] as! [[String: AnyObject]]
            
            // Parse users first
            for u in users {
                let user = User.createOrUpdateUserWithObject(u)
                user?.isFollowing = NSNumber(bool: true)
                
            }
            
            for t in tweets {
                Tweet.createOrUpdateTweetWithObject(t)
            }
            
            // Save the shared context
            DataManager.sharedInstance().saveContext(nil)

            self.updateViewsWithCoreData()
            
        }) { (task, error) in
            print("Failed to refresh tweets with error: \(error.localizedDescription)")
        }
    }

    // MARK: ViewProfileAlertViewDelegate methods

    func viewProfileAlertViewDidTapUnfollow(alertView: ViewProfileAlertView) {
        let user = alertView.user!
        alertView.dismissWithCompletion { (av: SeshBlurWindow!) -> Void in
            let animationView = SeshConfirmationAnimationView(frame: self.view.bounds)
            animationView.alpha = 0.0;
            animationView.confirmationText = "Unfollowed!"
            self.navigationController!.view.addSubview(animationView)

            UIView.animateWithDuration(0.3) { () -> Void in
                animationView.alpha = 1.0
            }

            TweedNetworking.editHandles(Array(), deletions: [user.screenName!], successHandler: { (task, responseObject) -> Void in
                user.isFollowing = NSNumber(bool: false)
                DataManager.sharedInstance().saveContext(nil)

                self.updateViewsWithCoreData()

                animationView.completionBlock = { (confirmationView: SeshConfirmationAnimationView!) -> Void in
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        animationView.alpha = 0.0
                    }, completion: { (success: Bool) -> Void in
                            animationView.removeFromSuperview()
                    })
                }
                animationView.startAnimating()
            }) { (task, error) -> Void in
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    animationView.alpha = 0.0
                    }, completion: { (success: Bool) -> Void in
                        animationView.removeFromSuperview()
                        SeshAlertView.init(swiftWithTitle: "Error!", message: "We couldn't unfollow \(user.displayName())! Please check your internet connection and try again!", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: ["OKAY"]).show()
                })
            }
        }

    }

}
