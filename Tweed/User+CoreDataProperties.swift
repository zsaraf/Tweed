//
//  User+CoreDataProperties.swift
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

extension User {

    @NSManaged var bio: String?
    @NSManaged var followersCount: NSNumber?
    @NSManaged var followingCount: NSNumber?
    @NSManaged var id: String?
    @NSManaged var isFollowing: NSNumber?
    @NSManaged var isRecommended: NSNumber?
    @NSManaged var location: String?
    @NSManaged var name: String?
    @NSManaged var profileBackgroundColor: String?
    @NSManaged var profileBannerImageUrl: String?
    @NSManaged var profileImageUrl: String?
    @NSManaged var screenName: String?
    @NSManaged var tweetCount: NSNumber?
    @NSManaged var tweets: NSSet?

}
