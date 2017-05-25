//
//  TwitterUser+CoreDataClass.swift
//  TwitterTag
//
//  Created by shashank kannam on 5/24/17.
//  Copyright © 2017 developer. All rights reserved.
//

import Foundation
import Twitter
import CoreData


public class TwitterUser: NSManagedObject {

    class func findOrCreateTwitterUser(matching twitterInfo: Twitter.User, in context: NSManagedObjectContext) throws -> TwitterUser {
        let request: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
        request.predicate = NSPredicate(format: "handle = %@", twitterInfo.screenName)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "TwitterUser: findOrCreateTwitterUser -- database inconsistency")
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let tweet = TwitterUser(context: context)
        tweet.handle = twitterInfo.screenName
        tweet.name = twitterInfo.name
        return tweet
    }
    
}
