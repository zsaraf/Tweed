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
        
        var user: User?
        if (tweetObject["user_id"] == nil) {
            user = User.createOrUpdateUserWithObject(tweetObject["user"] as! [String: AnyObject])
        } else {
            user = User.getUserWithId(String(tweetObject["user_id"] as! Int))
        }
        if (user == nil) {
            print("Couldn't find the user for the tweet")
        }
        tweet!.user = user
        tweet!.text = tweetObject["text"] as? String
        tweet!.createdAt = NSDate.twitterDateFromString(tweetObject["created_at"] as! String)

        let mediaObjects = tweetObject["media"] as? [[String: AnyObject]]
        if mediaObjects != nil {
            for mediaObject in mediaObjects! {
                let media = Media.createOrUpdateMediaWithObject(mediaObject)
                media?.tweet = tweet!
            }
        }

        let mentionObjects = tweetObject["mentions"] as? [[String: AnyObject]]
        if mentionObjects != nil {
            for mentionObject in mentionObjects! {
                let mention = Mention.createOrUpdateMentionWithObject(mentionObject)
                mention?.tweet = tweet!
            }
        }

        let urlObjects = tweetObject["urls"] as? [String: AnyObject]
        if urlObjects != nil {
            for (fakeUrl, realUrl) in urlObjects! {
                let url = Url.createOrUpdateUrlWithObject(fakeUrl, realUrl: realUrl as! String)
                url?.tweet = tweet!
            }
        }
        
        if ((tweetObject["original_tweet"] as? [String: AnyObject]) != nil) {
            tweet!.originalTweet = self.createOrUpdateTweetWithObject(tweetObject["original_tweet"] as! [String: AnyObject])
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

    class func refreshTweets(completionHandler: ((success: Bool) -> Void)?) {
        TweedNetworking.refreshTweets({ (task, responseObject) in

            self.parseResponse(responseObject)
            completionHandler?(success: true)
        }) { (task, error) in
            completionHandler?(success: false)
            print("Failed to refresh tweets with error: \(error.localizedDescription)")
        }
    }

    class func loadMoreTweets(completionHandler: ((success: Bool) -> Void)?) {
        TweedNetworking.loadMoreTweets({ (task, responseObject) in

            self.parseResponse(responseObject)
            completionHandler?(success: true)

        }) { (task, error) in
            completionHandler?(success: false)
            print("Failed to load more tweets with error: \(error.localizedDescription)")
        }
        
    }

    class func parseResponse(responseObject: AnyObject?) {
        // Get users and tweets
        let users = responseObject!["twitter_users"] as! [[String: AnyObject]]
        let tweets = responseObject!["tweets"] as! [[String: AnyObject]]

        // Parse users first
        for u in users {
            let user = User.createOrUpdateUserWithObject(u)
            user?.isFollowing = NSNumber(bool: true)

        }

        for t in tweets {
            Tweet.createOrUpdateTweetWithObject(t)
        }

        // Save the shared context
        DataManager.sharedInstance().saveContext(nil)
    }

}
