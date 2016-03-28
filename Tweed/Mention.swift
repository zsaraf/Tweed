//
//  Mention.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/27/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import Foundation
import CoreData


class Mention: NSManagedObject {

    class func createOrUpdateMentionWithObject(mentionObject: [String: AnyObject]) -> Mention? {

        let moc = DataManager.sharedInstance().managedObjectContext!!
        var mention: Mention?
        let request = NSFetchRequest()
        let predicate = NSPredicate(format: "id == %@", String(mentionObject["id"] as! Int))
        request.entity = NSEntityDescription.entityForName("Mention", inManagedObjectContext: moc)
        request.predicate = predicate
        var results: [AnyObject]?
        do {
            results = try moc.executeFetchRequest(request)
        } catch let error as NSError {
            print(error.localizedDescription)
        }

        if (results == nil || results?.count == 0) {
            mention = NSEntityDescription.insertNewObjectForEntityForName("Mention", inManagedObjectContext: moc) as? Mention
        } else if (results?.count == 1) {
            mention = results![0] as? Mention
        } else {
            print("Multiple mentions found with same Id: #fatal")
            return nil;
        }

        mention!.id = mentionObject["id"] as! Int
        mention!.screenName = mentionObject["screen_name"] as? String
        mention!.name = mentionObject["name"] as? String
        
        return mention!
    }


}
