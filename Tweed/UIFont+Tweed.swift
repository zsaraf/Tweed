//
//  UIFont+Tweed.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/25/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import UIKit

extension UIFont {

    static func SFMedium(size: CGFloat) -> UIFont? {
        return UIFont(name: "SFUIText-Medium", size: size)
    }
    
    static func SFRegular(size: CGFloat) -> UIFont? {
        return UIFont(name: "SFUIText-Regular", size: size)
    }
    
    static func lightGotham(size: CGFloat) -> UIFont? {
        return UIFont(name: "Gotham-Light", size: size)
    }

    static func bookGotham(size: CGFloat) -> UIFont? {
        return UIFont(name: "Gotham-Book", size: size)
    }

    static func mediumGotham(size: CGFloat) -> UIFont? {
        return UIFont(name: "Gotham-Medium", size: size)
    }
    
    static func printDebugFonts() {
        let families = UIFont.familyNames()
        for i in 0 ..< families.count {
            print(UIFont.fontNamesForFamilyName(families[i]))
        }
    }

}