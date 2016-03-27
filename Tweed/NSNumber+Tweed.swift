//
//  NSNumber+Tweed.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/27/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import Foundation

extension NSNumber {

    func abbreviated() -> String {
        // less than 1000, no abbreviation
        var n = (self as Double)
        if n < 1000 {
            return "\(self)"
        }

        let formatter = NSNumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0

        // less than 1 million, abbreviate to thousands
        if n < 1000000 {
            n = Double( floor(n/100)/10 )
            return "\(formatter.stringFromNumber(n)!)K"
        }

        // more than 1 million, abbreviate to millions
        n = Double( floor(n/100000)/10 )
        return "\(formatter.stringFromNumber(n)!)M"
    }

}