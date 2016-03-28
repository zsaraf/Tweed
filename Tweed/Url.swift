//
//  Url.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/27/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import Foundation
import CoreData


class Url: NSManagedObject {

    class func createOrUpdateUrlWithObject(fakeUrl: String, realUrl: String) -> Url? {

        let moc = DataManager.sharedInstance().managedObjectContext!!
        var url: Url?

        url = NSEntityDescription.insertNewObjectForEntityForName("Url", inManagedObjectContext: moc) as? Url

        url?.fakeUrl = fakeUrl
        url?.realUrl = realUrl
        
        return url!
    }

}
