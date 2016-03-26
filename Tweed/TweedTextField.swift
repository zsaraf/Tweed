//
//  TweedTextField.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/26/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import UIKit
import SnapKit

class TweedTextField: UITextField {
    let iconView: UIImageView
    let lineView = UIView()
    var iconWrapperViewHeightConstraint: Constraint?

    init(frame: CGRect, icon: UIImage) {
        self.iconView = UIImageView(image: icon.imageWithRenderingMode(.AlwaysTemplate))

        super.init(frame: frame)

        self.setupTextField()
        self.setupIconView()
        self.setupLineView()
    }

    func setupTextField() {
        self.font = UIFont.bookGotham(15.0)
        self.textColor = UIColor.tweedBlue()
        self.attributedPlaceholder = NSAttributedString(string: "Enter username handle", attributes: [NSForegroundColorAttributeName: self.textColor!, NSFontAttributeName: self.font!])
    }

    func setupIconView() {
        self.iconView.contentMode = .ScaleAspectFit
        self.iconView.tintColor = UIColor.tweedBlue()

        let iconWrapperView = UIView()
        iconWrapperView.addSubview(self.iconView)

        self.iconView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(iconWrapperView).offset(2)
            make.centerY.equalTo(iconWrapperView)
            make.width.equalTo(self.iconView.snp_height)
            make.top.bottom.equalTo(iconWrapperView).inset(1)
        }

        iconWrapperView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(UIScreen.mainScreen().bounds.size.width * 0.07)
            self.iconWrapperViewHeightConstraint = make.height.equalTo(20.0).constraint
        }

        self.leftView = iconWrapperView
        self.leftViewMode = .Always
    }

    func setupLineView() {
        self.lineView.backgroundColor = UIColor.tweedBlue()
        self.addSubview(self.lineView)

        self.lineView.snp_makeConstraints { (make) -> Void in
            make.bottom.left.right.equalTo(self)
            make.height.equalTo(1.0)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.iconWrapperViewHeightConstraint?.updateOffset(self.bounds.size.height)
    }

    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.size.width * 0.7, UIScreen.mainScreen().bounds.size.height * 0.03)
    }

}
