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
    
    var container = AppDelegate.container

    override func insertTweets(newTweets: [Twitter.Tweet]) {
        super.insertTweets(newTweets: newTweets)
        updateDatabase(with: newTweets)
    }
    
    private func updateDatabase(with tweets: [Twitter.Tweet]) {
        print("Database start loading")
        container?.performBackgroundTask{ [weak self] context in
            for tweetInfo in tweets {
                _ = try? Tweet.findOrCreateTweet(matching: tweetInfo, in: context)
            }
            try? context.save()
            print("Database done loading")
            self?.printDatabaseStatistics()
        }
    }
    
    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
            context.perform {
                Thread.isMainThread ? print("Main Thread") : print("Background Thread")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TweetersSegue" {
            if let dest = segue.destination as? SmashTweeterTableViewController {
                dest.container = container
                dest.mention = searchText
            }
        }
    }

}
