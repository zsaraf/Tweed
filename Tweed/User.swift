//
//  User.swift
//  Tweed
//
//  Created by Raymond Kennedy on 3/26/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import Foundation
import CoreData


class User: NSManagedObject {

    class func createOrUpdateUserWithObject(userObject: [String: AnyObject]) -> User? {
        
        let moc = DataManager.sharedInstance().managedObjectContext!!
        var user: User?
        let request = NSFetchRequest()
        let predicate = NSPredicate(format: "id == %@", String(userObject["id"] as! Int))
        request.entity = NSEntityDescription.entityForName("User", inManagedObjectContext: moc)
        request.predicate = predicate
        var results: [AnyObject]?
        do {
            results = try moc.executeFetchRequest(request)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        if (results == nil || results?.count == 0) {
            user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: moc) as? User
        } else if (results?.count == 1) {
            user = results![0] as? User
        } else {
            print("Should not happen help!")
            return nil;
        }
        
        user!.id = String(userObject["id"] as! Int)
        user!.screenName = userObject["screen_name"] as? String
        user!.profileImageUrl = (userObject["profile_image"] as? String)?.stringByReplacingOccurrencesOfString("_normal", withString: "")
        user!.name = userObject["name"] as? String
        user!.followersCount = NSNumber(integer: (userObject["followers_count"] as! Int))
        user!.location = userObject["location"] as? String
        user!.bio = userObject["description"] as? String
        user!.profileBackgroundColor = userObject["profile_background_color"] as? String
        user!.profileBackgroundImageUrl = userObject["profile_background_image"] as? String
        
        DataManager.sharedInstance().saveContext(nil)
        return user
        
        
    }
    
    // Insert code here to add functionality to your managed object subclass
    class func testUser() -> User? {
        let moc = DataManager.sharedInstance().managedObjectContext!!
        var user: User?
        let request = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName("User", inManagedObjectContext: moc)
        var results: [AnyObject]?
        do {
            results = try moc.executeFetchRequest(request)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        if (results == nil || results?.count == 0) {
            user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: moc) as? User
        } else if (results?.count == 1) {
            user = results![0] as? User
        } else {
            print("Should not happen help!")
            return nil;
        }
        
        user!.screenName = "rayfkjklo.heysaomee"
        user!.name = "RaymondLong Kennedy"
        user!.profileImageUrl = "https://placeholdit.imgix.net/~text?txtsize=20&txt=100%C3%97100&w=100&h=100"
        DataManager.sharedInstance().saveContext(nil)
        return user
    }
    
    func displayName() -> String {
        var abbreviatedName = self.name?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let components = abbreviatedName?.componentsSeparatedByString(" ")
        abbreviatedName = components![0]
        if (components?.count > 1) {
            let lastPart = components![(components?.count)! - 1]
            let range = lastPart.startIndex..<lastPart.startIndex.advancedBy(1)
            abbreviatedName = abbreviatedName?.stringByAppendingFormat(" %@.", lastPart.substringWithRange(range))
        }
        return abbreviatedName!
    }

}
