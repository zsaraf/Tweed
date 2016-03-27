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
        user!.followingCount = NSNumber(integer: (userObject["following_count"] as! Int))
        user!.tweetCount = NSNumber(integer: (userObject["tweets_count"] as! Int))
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
        } else {
            user = results![0] as? User
        }
        
        user!.screenName = "rayfk"
        user!.name = "RaymondLong Kennedy"
        user!.profileImageUrl = "https://media.licdn.com/mpr/mpr/shrinknp_200_200/p/7/000/211/124/06ee517.jpg"
        user!.profileBackgroundImageUrl = "http://www.f-covers.com/namecovers/image/i-love-my-life.jpg"
        user!.bio = "Hey my name is Raymond I love doing fun things and going out, and having fun, and run on sentences."
        user!.profileBackgroundColor = "FF55FF"
        user!.location = "Palo Alto, CA"
        user!.followersCount = 236000000
        user!.followingCount = 180
        user!.tweetCount = 2360
        DataManager.sharedInstance().saveContext(nil)
        return user
    }
}
