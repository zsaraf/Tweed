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
import DGElasticPullToRefresh
import UIScrollView_InfiniteScroll
import JTSImageViewController

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FollowViewControllerDelegate, ViewProfileAlertViewDelegate, TweetTableViewCellDelegate {

    let tableView = UITableView()

    private var tweets = Tweet.getAllTweets()
    private var followingView: FollowingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.tweedBlue()
        self.automaticallyAdjustsScrollViewInsets = false

        self.setupNavigationBar()
        self.setupTableView()
        self.setupFollowingView()

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


    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 60.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = .None
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.tableView)

        self.shyNavBarManager.scrollView = self.tableView

        self.tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }

        self.addPullToRefresh()
        self.addInfiniteScroll()
    }
    
    func setupFollowingView() {
        self.followingView = FollowingView(following: User.getFollowingUsers()!, profileAlertViewDelegate: self)
        self.followingView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height * 0.15)
        self.shyNavBarManager.extensionView = self.followingView
    }
    
    deinit {
        self.tableView.dg_removePullToRefresh()
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
            cell?.delegate = self
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
        let alertView = ViewProfileAlertView(user: user, hidesFollowButton: false)
        alertView.viewProfileDelegate = self
        alertView.show()
    }

    // MARK: Action methods

    func addFollows(button: UIButton) {
        let rootView = self.navigationController!.view
        let blurredImage = UIImage.blurredImageWithRootView(rootView, tintColor: UIColor(white: 0, alpha: 0.5), radius: 12, saturationDeltaFactor: 1.1)

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
        self.updateViewsWithCoreData()
        self.refreshTweets()
    }
    
    // MARK: Private Methods

    func updateViewsWithCoreData() {
        // Assign tweets and resume operations as normal
        self.tweets = Tweet.getAllTweets()
        self.followingView.refreshCollectionView(User.getFollowingUsers()!)
        self.tableView.reloadData()
    }
    
    func addPullToRefresh() {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.whiteColor()
        self.tableView.dg_addPullToRefreshWithActionHandler({
            self.refreshTweets()
            
            }, loadingView: loadingView)
        self.tableView.dg_setPullToRefreshFillColor(UIColor.tweedBlue())
        self.tableView.dg_setPullToRefreshBackgroundColor(UIColor.whiteColor())
    }
    
    func addInfiniteScroll() {
        tableView.infiniteScrollIndicatorStyle = .Gray
        self.tableView.addInfiniteScrollWithHandler { (scrollView) in
            self.loadMoreTweets()
        }
    }
    
    func parseResponse(responseObject: AnyObject?) {
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
    }
    
    func loadMoreTweets() {
        TweedNetworking.loadMoreTweets({ (task, responseObject) in
            
            self.parseResponse(responseObject)
            self.updateViewsWithCoreData()
            self.tableView.finishInfiniteScroll()
            
        }) { (task, error) in
            print("Failed to load more tweets with error: \(error.localizedDescription)")
        }

    }

    func refreshTweets() {
        TweedNetworking.refreshTweets({ (task, responseObject) in
            
            self.parseResponse(responseObject)
            self.updateViewsWithCoreData()
            self.tableView.dg_stopLoading()
            
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

    // MARK: TweetTableViewCellDelegate methods

    func tweetTableViewCellDidTapMedia(cell: TweetTableViewCell, media: Media) {
        let image = cell.mediaImageView.image!
        let info = JTSImageInfo()
        info.image = image
        info.referenceRect = cell.mediaImageView.frame
        info.referenceView = cell.mediaImageView.superview!

        let imageViewer = JTSImageViewController(imageInfo: info, mode: .Image, backgroundStyle: .Scaled)
        imageViewer.showFromViewController(self, transition: .FromOriginalPosition)
    }

    func tweetTableViewCellDidTapMention(cell: TweetTableViewCell, mention: Mention) {
        let webVC = TweedWebViewController(startingUrl: "https://www.twitter.com/\(mention.screenName!)")
        self.navigationController?.pushViewController(webVC, animated: true)
    }

    func tweetTableViewCellDidTapUrl(cell: TweetTableViewCell, url: String) {
        let webVC = TweedWebViewController(startingUrl: url)
        self.navigationController?.pushViewController(webVC, animated: true)
    }

}
