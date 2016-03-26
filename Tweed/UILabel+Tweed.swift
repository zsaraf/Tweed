//
//  UILabel+Tweed.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/25/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import UIKit

extension UILabel {

    convenience init(font: UIFont, textColor: UIColor!, text: String, textAlignment: NSTextAlignment) {
        self.init(frame: CGRectZero)

        self.font = font
        self.textColor = textColor
        self.text = text
        self.textAlignment = textAlignment
    }

}
