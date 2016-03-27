//
//  AddedHandleTableViewCell.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/26/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import UIKit

class AddedHandleTableViewCell: UITableViewCell {
    let addedHandleLabel = UILabel(font: UIFont.SFRegular(13.0)!, textColor: UIColor.grayColor(), text: "", textAlignment: .Center)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = UIColor.clearColor()

        self.contentView.addSubview(self.addedHandleLabel)

        self.addedHandleLabel.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(self.contentView)
            make.top.bottom.equalTo(self.contentView).inset(5)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
