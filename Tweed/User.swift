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
        var user = self.getUserWithId(String(userObject["id"] as! Int))
        if (user == nil) {
            user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: moc) as? User
            user!.isRecommended = NSNumber(bool: false)
            user!.isFollowing = NSNumber(bool: false)
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
        
        return user
    }
    
    class func getUserWithId(id: String) -> User? {
        let moc = DataManager.sharedInstance().managedObjectContext!!
        let request = NSFetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        request.entity = NSEntityDescription.entityForName("User", inManagedObjectContext: moc)
        request.predicate = predicate
        var results: [AnyObject]?
        do {
            results = try moc.executeFetchRequest(request)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        if (results == nil || results?.count == 0) {
            return nil;
        } else if (results?.count == 1) {
            return results![0] as? User
        } else {
            print("Should not happen help!")
            return nil;
        }
    }
    
    class func getRecommendedUsers() -> [User]? {
        let moc = DataManager.sharedInstance().managedObjectContext!!
        let request = NSFetchRequest()
        let predicate = NSPredicate(format: "isRecommended == %@ && isFollowing == %@", NSNumber(bool: true), NSNumber(bool: false))
        request.entity = NSEntityDescription.entityForName("User", inManagedObjectContext: moc)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.predicate = predicate
        var results: [AnyObject]?
        do {
            results = try moc.executeFetchRequest(request)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        if (results == nil || results?.count == 0) {
            return [User]();
        } else {
            return results as? [User]
        }
    }
    
    class func removeAllRecommendedUsers() {
        let results = self.getRecommendedUsers()
        
        for ru in results! {
            DataManager.sharedInstance().deleteObject(ru, context: nil)
        }
    }
    
    class func refreshRecommendedUsers(withCompletionHandler completionHandler: (() -> Void)?) {
        
        TweedNetworking.getSuggestions({ (task, responseObject) in
            
            // Remove all the old ones
            self.removeAllRecommendedUsers()
            
            // Insert the new ones
            for object in responseObject as! [[String: AnyObject]] {
                let user = self.createOrUpdateUserWithObject(object)
                user?.isRecommended = NSNumber(bool: true)
            }
            
            // Save the context
            DataManager.sharedInstance().saveContext(nil)
            
            if (completionHandler != nil) {
                completionHandler!()
            }
            
        }) { (task, error) in
            print("error")
        }
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
    
    func smallProfileImageUrl() -> String {
        return (self.profileImageUrl?.stringByReplacingOccurrencesOfString(".jpeg", withString: "_normal.jpeg"))!
    }

    
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
}
