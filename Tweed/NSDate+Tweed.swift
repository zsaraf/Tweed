//
//  NSDate+Tweed.swift
//  Tweed
//
//  Created by Raymond Kennedy on 3/27/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import UIKit

extension NSDate {

    static func twitterDateFromString(string: String) -> NSDate? {
        let df = NSDateFormatter()
        df.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        df.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        return df.dateFromString(string)
    }
    
}
