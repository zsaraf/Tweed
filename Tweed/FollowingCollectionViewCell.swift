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
            imageView.sd_setImageWithURL(NSURL(string: user!.profileImageUrl!))
        }
    }

    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFill
        self.contentView.addSubview(imageView)

        imageView.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(self.contentView.snp_width).multipliedBy(0.7)
            make.center.equalTo(self.contentView)
        }
        imageView.layer.cornerRadius = (self.bounds.size.width * 0.7)/2.0
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        imageView.layer.cornerRadius = imageView.bounds.size.width/2.0
    }

}
