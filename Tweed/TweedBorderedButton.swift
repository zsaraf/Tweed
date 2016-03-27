//
//  TweedBorderedButton.swift
//  Tweed
//
//  Created by Raymond Kennedy on 3/26/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import UIKit

enum TweedBorderedButtonType {
    case Gray;
    case Blue;
}

class TweedBorderedButton: UIButton {
    var type: TweedBorderedButtonType

    struct TweedBorderedButtonConstants {
        static let BorderWidth: CGFloat = 1.0
        static let CornerRadius: CGFloat = 4.0
        static let FontSize: CGFloat = 14
        static let TopPadding: CGFloat = 4
        static let SidePading: CGFloat = 20
    }
    
    init(type: TweedBorderedButtonType) {
        self.type = type

        super.init(frame: CGRectZero)
        self.setupDefaultValues()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupDefaultValues() {
        self.layer.borderWidth = TweedBorderedButtonConstants.BorderWidth
        self.layer.cornerRadius = TweedBorderedButtonConstants.CornerRadius
        self.clipsToBounds = true
        self.titleLabel?.font = UIFont.SFRegular(TweedBorderedButtonConstants.FontSize)!
        self.titleLabel?.lineBreakMode = .ByWordWrapping
        self.titleEdgeInsets = UIEdgeInsets(top: TweedBorderedButtonConstants.TopPadding, left: TweedBorderedButtonConstants.SidePading, bottom: TweedBorderedButtonConstants.TopPadding, right: TweedBorderedButtonConstants.SidePading)

        if self.type == .Blue {
            self.layer.borderColor = UIColor.tweedLightBlue().CGColor
            self.setTitleColor(UIColor.tweedLightBlue(), forState: .Normal)
            self.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            self.setBackgroundImage(UIImage(color: UIColor.tweedLightBlue()), forState: .Highlighted)
        } else {
            self.layer.borderColor = UIColor.tweedGray().CGColor
            self.setTitleColor(UIColor.tweedGray(), forState: .Normal)
            self.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            self.setBackgroundImage(UIImage(color: UIColor.tweedGray()), forState: .Highlighted)
        }
    }
    
    func typicalSize() -> CGSize {
        let labelSize = titleLabel?.sizeThatFits(CGSizeMake(UIScreen.mainScreen().bounds.size.width, self.frame.size.height)) ?? CGSizeZero
        let width = labelSize.width
        let desiredButtonSize = CGSizeMake(width + titleEdgeInsets.left + titleEdgeInsets.right, labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom)
        return desiredButtonSize
    }
    
    
    override func intrinsicContentSize() -> CGSize {
        let labelSize = titleLabel?.sizeThatFits(CGSizeMake(UIScreen.mainScreen().bounds.size.width, self.frame.size.height)) ?? CGSizeZero
        let width = labelSize.width
        let desiredButtonSize = CGSizeMake(width + titleEdgeInsets.left + titleEdgeInsets.right, labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom)
        
        return desiredButtonSize
    }

    
    
}
