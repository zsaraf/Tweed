//
//  RecommendationsView.swift
//  Tweed
//
//  Created by Raymond Kennedy on 3/26/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import UIKit

class RecommendationsView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, RecommendationTableViewCellDelegate {

    struct RecommendationsViewConstants {
        struct CollectionView {
            static let CellWidth = UIScreen.mainScreen().bounds.size.width * 0.7
            static let MinimumLineSpacing: CGFloat = 0.0
            static let MinimumInterItemSpacing: CGFloat = 0.0
            static let ReuseIdentifier = "recommendationCell"
        }
    }

    var recommendations: [User] {
        didSet {
            self.toggleViewVisibility()
            if (self.collectionView != nil) {
                self.collectionView.reloadData()
            }
        }
    }
    
    var collectionView: UICollectionView!
    private var loadingLabel = UILabel(font: UIFont.SFRegular(18)!, textColor: UIColor.whiteColor(), text: "Loading...", textAlignment: .Left)
    
    private var dataSource: FollowViewController?
    
    // MARK: Init Methods
    
    init(recommendations: [User], dataSource: FollowViewController) {
        self.recommendations = recommendations
        self.dataSource = dataSource
        super.init(frame: CGRectZero)
        self.setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup Methods
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = RecommendationsViewConstants.CollectionView.MinimumLineSpacing
        layout.minimumInteritemSpacing = RecommendationsViewConstants.CollectionView.MinimumInterItemSpacing
        let itemHeight = UIScreen.mainScreen().bounds.size.height * CGFloat(FollowViewController.FollowViewConstants.RecommendationsHeightPercent)
        layout.itemSize = CGSize(width: RecommendationsViewConstants.CollectionView.CellWidth, height: itemHeight - 1)
        layout.sectionInset = UIEdgeInsetsZero
        self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.alwaysBounceHorizontal = true
        self.collectionView.registerClass(RecommendationTableViewCell.self, forCellWithReuseIdentifier: RecommendationsViewConstants.CollectionView.ReuseIdentifier)
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    
    
    func setupViews() {
        self.setupCollectionView()
        self.collectionView.backgroundColor = UIColor.clearColor()
        
        self.addSubview(self.collectionView)
        self.collectionView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        self.addSubview(self.loadingLabel)
        self.loadingLabel.snp_makeConstraints { (make) in
            make.left.right.equalTo(self).inset(20)
            make.centerY.equalTo(self)
        }
        
        self.toggleViewVisibility()
        
    }
    
    func toggleViewVisibility() {
        if (self.recommendations.count == 0) {
            self.collectionView.hidden = true
            self.loadingLabel.hidden = false
        } else {
            self.collectionView.hidden = false
            self.loadingLabel.hidden = true
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(RecommendationsViewConstants.CollectionView.ReuseIdentifier, forIndexPath: indexPath) as! RecommendationTableViewCell
        let recommendation = self.recommendations[indexPath.row]
        cell.user = recommendation
        cell.delegate = self
        if (self.dataSource!.addedHandles.contains((recommendation.screenName)!)) {
            cell.setFollowButtonTitle("Unfollow");
        } else {
            cell.setFollowButtonTitle("Follow");
        }
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recommendations.count
    }
    
    // MARK: RecommendationTableViewCellDelegate Methods
    
    func followButtonHit(screenName: String, cell: UICollectionViewCell) {
        if (self.dataSource!.addedHandles.contains(screenName)) {
            self.dataSource!.removeScreenName(screenName)
        } else {
            self.dataSource!.addScreenName(screenName)
        }
        
    }
    
    func profilePictureTapped(user: User, cell: UICollectionViewCell) {
        let alertView = ViewProfileAlertView(user: user, hidesFollowButton: true)
        alertView.show()
    }
    
    
}
