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

    enum TweedTextFieldAccessoryType {
        case None, ActivityIndicator, Check, X;
    }

    let leftIconView: UIImageView
    let rightIconView = UIImageView(frame: CGRectMake(0, 0, 20, 20))
    let rightActivityIndicatorView = SeshActivityIndicator(frame: CGRectMake(0, 0, 20, 20))
    let lineView = UIView()

    var iconWrapperViewHeightConstraint: Constraint?

    var accessoryType = TweedTextFieldAccessoryType.None {
        didSet {
            if accessoryType == .None {
                self.rightView = nil
                self.rightViewMode = .Never
            } else if accessoryType == .ActivityIndicator {
                self.rightActivityIndicatorView.startAnimating()
                self.rightView = rightActivityIndicatorView
                self.rightViewMode = .Always
            } else {
                if accessoryType == .Check {
                    self.rightIconView.image = UIImage(named: "check")?.imageWithRenderingMode(.AlwaysTemplate)
                    self.rightIconView.tintColor = UIColor.tweedGreen()
                } else {
                    self.rightIconView.image = UIImage(named: "cancel")?.imageWithRenderingMode(.AlwaysTemplate)
                    self.rightIconView.tintColor = UIColor.tweedRed()
                }
                self.rightView = self.rightIconView
                self.rightViewMode = .Always
            }
        }
    }

    init(frame: CGRect, icon: UIImage) {
        self.leftIconView = UIImageView(image: icon.imageWithRenderingMode(.AlwaysTemplate))

        super.init(frame: frame)

        self.setupTextField()
        self.setupLeftIconView()
        self.setupRightIconView()
        self.setupLineView()
    }

    func setupTextField() {
        self.font = UIFont.SFRegular(15.0)
        self.textColor = UIColor.tweedBlue()
        self.attributedPlaceholder = NSAttributedString(string: "Enter username handle", attributes: [NSForegroundColorAttributeName: self.textColor!, NSFontAttributeName: self.font!])
    }

    func setupLeftIconView() {
        self.leftIconView.contentMode = .ScaleAspectFit
        self.leftIconView.tintColor = UIColor.tweedBlue()

        let iconWrapperView = UIView()
        iconWrapperView.addSubview(self.leftIconView)

        self.leftIconView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(iconWrapperView).offset(2)
            make.centerY.equalTo(iconWrapperView)
            make.width.equalTo(self.leftIconView.snp_height)
            make.top.bottom.equalTo(iconWrapperView).inset(5)
        }

        iconWrapperView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(UIScreen.mainScreen().bounds.size.width * 0.07)
            self.iconWrapperViewHeightConstraint = make.height.equalTo(20.0).constraint
        }

        self.leftView = iconWrapperView
        self.leftViewMode = .Always
    }

    func setupRightIconView() {
        self.rightActivityIndicatorView.startAnimating()
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
        return CGSizeMake(UIScreen.mainScreen().bounds.size.width * 0.7, UIScreen.mainScreen().bounds.size.height * 0.04)
    }

}
