//
//  Media+CoreDataProperties.swift
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

extension Media {

    @NSManaged var endIdx: NSNumber?
    @NSManaged var height: NSNumber?
    @NSManaged var id: NSNumber?
    @NSManaged var mediaUrl: String?
    @NSManaged var startIdx: NSNumber?
    @NSManaged var width: NSNumber?
    @NSManaged var tweet: Tweet?

}
