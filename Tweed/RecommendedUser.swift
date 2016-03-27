//
//  RecommendedUser.swift
//  Tweed
//
//  Created by Raymond Kennedy on 3/26/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import Foundation
import CoreData


class RecommendedUser: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    class func createOrUpdateRecommendedUser(ruObject: [String: AnyObject]) -> RecommendedUser {
        let moc = DataManager.sharedInstance().managedObjectContext!
        let recommendedUser = NSEntityDescription.insertNewObjectForEntityForName("RecommendedUser", inManagedObjectContext: moc) as! RecommendedUser
        recommendedUser.user = User.createOrUpdateUserWithObject(ruObject)
        return recommendedUser
    }

    class func refreshRecommendedUsers(withCompletionHandler completionHandler: (() -> Void)?) {
        
        TweedNetworking.getSuggestions({ (task, responseObject) in
            
            // Remove all the old ones
            self.removeAllRecommendedUsers()
            
            // Insert the new ones
            for object in responseObject as! [[String: AnyObject]] {
                self.createOrUpdateRecommendedUser(object)
            }
            
            // Save the context
            DataManager.sharedInstance().saveContext(nil)
            
            if (completionHandler != nil) {
                completionHandler!()
            }
            
            }) { (task, error) in
                
        }
    }
    
    class func getAllRecommendedUsers() -> [RecommendedUser] {
        let moc = DataManager.sharedInstance().managedObjectContext!
        let allRUs = NSFetchRequest()
        allRUs.entity = NSEntityDescription.entityForName("RecommendedUser", inManagedObjectContext: moc)
        allRUs.includesPropertyValues = false
        var results: [AnyObject]?
        do {
            results = try moc.executeFetchRequest(allRUs)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return results as! [RecommendedUser]

    }
    
    class func removeAllRecommendedUsers() {
        let results = self.getAllRecommendedUsers()
        
        for ru in results {
            DataManager.sharedInstance().deleteObject(ru, context: nil)
        }

    }
    
}
