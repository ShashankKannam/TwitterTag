//
//  Tweet+CoreDataClass.swift
//  TwitterTag
//
//  Created by shashank kannam on 5/24/17.
//  Copyright © 2017 developer. All rights reserved.
//

import Foundation
import CoreData
import Twitter


public class Tweet: NSManagedObject {
    
    class func findOrCreateTweet(matching twitterInfo: Twitter.Tweet, in context: NSManagedObjectContext) throws -> Tweet {
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "uniqueID = %@", twitterInfo.identifier)
        
        do {
        let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count > 1, "Tweet: findOrCreateTweet -- database inconsistency")
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let tweet = Tweet(context: context)
        tweet.uniqueID = twitterInfo.identifier
        tweet.tweetText = twitterInfo.text
        tweet.created = twitterInfo.created as NSDate
        tweet.toTwitterUser = try? TwitterUser.findOrCreateTwitterUser(matching: twitterInfo.user, in: context)
        return tweet
    }
    
}
