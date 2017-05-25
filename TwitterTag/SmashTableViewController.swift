//
//  SmashTableViewController.swift
//  TwitterTag
//
//  Created by shashank kannam on 5/24/17.
//  Copyright © 2017 developer. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class SmashTableViewController: TweetTableViewController {

    override func insertTweets(newTweets: [Twitter.Tweet]) {
        super.insertTweets(newTweets: newTweets)
        updateDatabase(with: newTweets)
    }
    
    private func updateDatabase(with tweets: [Twitter.Tweet]) {
        AppDelegate.container?.performBackgroundTask{ context in
            for tweetInfo in tweets {
                _ = try? Tweet.findOrCreateTweet(matching: tweetInfo, in: context)
            }
            try? context.save()
        }
        printDatabaseStatistics()
    }
    
    private func printDatabaseStatistics() {
        if let context = AppDelegate.context {
            let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
            
            if let tweetCount = (try? context.fetch(request))?.count {
                print("Tweets count: \(tweetCount)")
            }
            
            if let tweeterCount = try? context.count(for: TwitterUser.fetchRequest()) {
                print("Tweeter count: \(tweeterCount)")
            }
        }
    }

}
