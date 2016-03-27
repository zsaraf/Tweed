//
//  Tweet.swift
//  Tweed
//
//  Created by Raymond Kennedy on 3/27/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import Foundation
import CoreData


class Tweet: NSManagedObject {

    // Insert code here to add functionality to your managed object subclass
    
    class func createOrUpdateTweetWithObject(tweetObject: [String: AnyObject]) -> Tweet? {
        
        let moc = DataManager.sharedInstance().managedObjectContext!!
        var tweet: Tweet?
        let request = NSFetchRequest()
        let predicate = NSPredicate(format: "id == %@", String(tweetObject["id"] as! Int))
        request.entity = NSEntityDescription.entityForName("Tweet", inManagedObjectContext: moc)
        request.predicate = predicate
        var results: [AnyObject]?
        do {
            results = try moc.executeFetchRequest(request)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        if (results == nil || results?.count == 0) {
            tweet = NSEntityDescription.insertNewObjectForEntityForName("Tweet", inManagedObjectContext: moc) as? Tweet
        } else if (results?.count == 1) {
            tweet = results![0] as? Tweet
        } else {
            print("Multiple tweets found with same Id: #fatal")
            return nil;
        }
        
        tweet!.id = String(tweetObject["id"] as! Int)
        let user = User.getUserWithId(String(tweetObject["user_id"] as! Int))
        if (user == nil) {
            print("Couldn't find the user for the tweet")
        }
        tweet!.user = user
        tweet!.text = tweetObject["text"] as? String
        tweet!.createdAt = NSDate.twitterDateFromString(tweetObject["created_at"] as! String)
        
        if (tweetObject["original_tweet"] != nil) {
            
        }
        
        return tweet

    }
    
    class func getAllTweets() -> [Tweet] {
        
        let moc = DataManager.sharedInstance().managedObjectContext!!
        let allTweets = NSFetchRequest()
        allTweets.entity = NSEntityDescription.entityForName("Tweet", inManagedObjectContext: moc)
        allTweets.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        allTweets.predicate = NSPredicate(format: "user.isFollowing == %@", NSNumber(bool: true))
        allTweets.includesPropertyValues = false
        var results: [AnyObject]?
        do {
            results = try moc.executeFetchRequest(allTweets)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return results as! [Tweet]

        
        
    }

}
