//
//  Url+CoreDataProperties.swift
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

extension Url {

    @NSManaged var fakeUrl: String?
    @NSManaged var realUrl: String?
    @NSManaged var tweet: Tweet?

}
