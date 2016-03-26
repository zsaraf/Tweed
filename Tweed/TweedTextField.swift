//
//  TweedTextField.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/26/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import UIKit

class TweedTextField: UITextField {
    let iconView: UIImageView
    let lineView = UIView()

    init(frame: CGRect, icon: UIImage) {
        self.iconView = UIImageView(image: icon.imageWithRenderingMode(.AlwaysTemplate))

        super.init(frame: frame)

        self.setupIconView()
        self.setupLineView()
    }

    func setupIconView() {
        self.iconView.contentMode = .ScaleAspectFit
        self.iconView.tintColor = UIColor.tweedBlue()

        let iconWrapperView = UIView()
        iconWrapperView.addSubview(self.iconView)
        self.iconView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(iconWrapperView).offset(5)
            make.centerY.equalTo(iconWrapperView)
            make.height.width.equalTo(iconWrapperView.snp_height).multipliedBy(0.8)
        }

        iconWrapperView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(UIScreen.mainScreen().bounds.size.width).multipliedBy(0.1)
        }

        self.leftView = self.iconView
        self.leftViewMode = .Always
    }

    func setupLineView() {
        self.lineView.backgroundColor = UIColor.tweedBlue()
        self.addSubview(self.lineView)

        self.lineView.snp_makeConstraints { (make) -> Void in
            make.bottom.left.right.equalTo(self)
            make.height.equalTo(3.0)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
