//
//  FollowingView.swift
//  Tweed
//
//  Created by Raymond Kennedy on 3/27/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import UIKit

class FollowingView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {

    private var collectionView: UICollectionView!
    private var following: [User]
    private var profileAlertViewDelegate: ViewProfileAlertViewDelegate?
    private var followingLabel = UILabel(font: UIFont.SFRegular(14)!, textColor: UIColor.whiteColor(), text: "Following", textAlignment: .Left)
    
        // Init Methods
    
    init(following: [User], profileAlertViewDelegate: ViewProfileAlertViewDelegate?) {
        self.following = following
        self.profileAlertViewDelegate = profileAlertViewDelegate
        super.init(frame: CGRectZero)
        
        // Setup the following label
        self.backgroundColor = UIColor.tweedBlue()
        self.addSubview(self.followingLabel)
        self.followingLabel.snp_makeConstraints { (make) in
            make.top.left.equalTo(self).inset(10)
        }
        
        
        self.setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Setup Methods
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let itemSize = UIScreen.mainScreen().bounds.size.height * 0.1
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.sectionInset = UIEdgeInsetsZero
        
        self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.alwaysBounceHorizontal = true
        self.collectionView.registerClass(FollowingCollectionViewCell.self, forCellWithReuseIdentifier: FollowingCollectionViewCell.Identifier)
        self.collectionView.backgroundColor = UIColor.tweedBlue()
        self.addSubview(self.collectionView)
        self.collectionView.snp_makeConstraints { (make) in
            make.top.equalTo(self.followingLabel.snp_bottom).offset(5)
            make.bottom.left.right.equalTo(self)
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(FollowingCollectionViewCell.Identifier, forIndexPath: indexPath) as! FollowingCollectionViewCell
        let user = self.following[indexPath.row]
        cell.user = user
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.following.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let user = self.following[indexPath.row]
        
        let alertView = ViewProfileAlertView(user: user, hidesFollowButton: false)
        alertView.viewProfileDelegate = self.profileAlertViewDelegate
        alertView.show()
    }
    
    // Public Methods
    
    func refreshCollectionView(following: [User]) {
        self.following = following
        self.collectionView.reloadData()
    }

}
