//
//  User+CoreDataProperties.swift
//  Tweed
//
//  Created by Raymond Kennedy on 3/26/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var id: String?
    @NSManaged var screenName: String?
    @NSManaged var name: String?
    @NSManaged var profileImageUrl: String?
    @NSManaged var location: String?
    @NSManaged var profileBackgroundColor: String?
    @NSManaged var followersCount: NSNumber?
    @NSManaged var bio: String?

}
