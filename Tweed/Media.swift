//
//  Media.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/27/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import Foundation
import CoreData


class Media: NSManagedObject {

    class func createOrUpdateMediaWithObject(mediaObject: [String: AnyObject]) -> Media? {

        let moc = DataManager.sharedInstance().managedObjectContext!!
        var media: Media?
        let request = NSFetchRequest()
        let predicate = NSPredicate(format: "id == %@", String(mediaObject["id"] as! Int))
        request.entity = NSEntityDescription.entityForName("Media", inManagedObjectContext: moc)
        request.predicate = predicate
        var results: [AnyObject]?
        do {
            results = try moc.executeFetchRequest(request)
        } catch let error as NSError {
            print(error.localizedDescription)
        }

        if (results == nil || results?.count == 0) {
            media = NSEntityDescription.insertNewObjectForEntityForName("Media", inManagedObjectContext: moc) as? Media
        } else if (results?.count == 1) {
            media = results![0] as? Media
        } else {
            print("Multiple medias found with same Id: #fatal")
            return nil;
        }

        media!.id = mediaObject["id"] as! Int

        let indices = mediaObject["indices"] as! [NSNumber]
        media!.startIdx = NSNumber(integer: (indices[0] as Int))
        media!.endIdx = NSNumber(integer: (indices[1] as Int))

        media!.mediaUrl = mediaObject["media_url"] as? String

        let size = ((mediaObject["sizes"] as! [String: AnyObject])["medium"] as! [String: AnyObject])
        media!.width = NSNumber(integer: (size["w"] as! Int))
        media!.height = NSNumber(integer: (size["h"] as! Int))

        return media!
    }

}
