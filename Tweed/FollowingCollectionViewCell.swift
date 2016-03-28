//
//  FollowingCollectionViewCell.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/27/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import UIKit
import SDWebImage

class FollowingCollectionViewCell: UICollectionViewCell {
    static let Identifier = "RecommendationTableViewCell"

    var user: User? {
        didSet {
            imageView.sd_setImageWithURL(NSURL(string: user!.bigProfileImageUrl()))
        }
    }

    let imageView = UIImageView()
    let imageViewWrapper = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        self.imageViewWrapper.layer.shadowColor = UIColor(white: 0.0, alpha: 1.0).CGColor
        self.imageViewWrapper.layer.shadowOffset = CGSizeMake(0, 1)
        self.imageViewWrapper.layer.shadowOpacity = 0.3
        self.imageViewWrapper.layer.shadowRadius = 3.0
        self.contentView.addSubview(self.imageViewWrapper)

        self.imageView.layer.masksToBounds = true
        self.imageView.clipsToBounds = true
        self.imageView.contentMode = .ScaleAspectFill
        self.imageViewWrapper.addSubview(imageView)

        self.imageViewWrapper.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(self.contentView.snp_width).multipliedBy(0.7)
            make.center.equalTo(self.contentView)
        }

        self.imageView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.imageViewWrapper)
        }
        self.imageView.layer.cornerRadius = (self.bounds.size.width * 0.7)/2.0
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageViewWrapper.bounds.size.width/2.0
        self.imageViewWrapper.layer.cornerRadius =  imageViewWrapper.bounds.size.width/2.0
    }

}
