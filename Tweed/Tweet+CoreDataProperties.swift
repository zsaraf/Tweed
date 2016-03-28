//
//  Tweet+CoreDataProperties.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/27/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tweet {

    @NSManaged var createdAt: NSDate?
    @NSManaged var id: String?
    @NSManaged var text: String?
    @NSManaged var copiedTweets: NSSet?
    @NSManaged var media: NSSet?
    @NSManaged var mentions: NSSet?
    @NSManaged var originalTweet: Tweet?
    @NSManaged var user: User?
    @NSManaged var urls: NSSet?

}
