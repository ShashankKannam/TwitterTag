//
//  SmashTweeterTableViewController.swift
//  TwitterTag
//
//  Created by shashank kannam on 5/24/17.
//  Copyright © 2017 developer. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class SmashTweeterTableViewController: FetchedResultsTableViewController {
    
//    override func viewDidLoad() {
//        fetchedResultsController?.delegate = self
//    }
    
    var mention: String? { didSet { updateUI() } }
    
    var container: NSPersistentContainer? = AppDelegate.container { didSet { updateUI() } }
    
    var fetchedResultsController: NSFetchedResultsController<TwitterUser>? {
        didSet {
            fetchedResultsController?.delegate = self
        }
    }
    
    private func updateUI() {
        guard let context = container?.viewContext, let mentions = mention else { return }
        let request: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "handle", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        request.sortDescriptors = [sortDescriptor]
        request.predicate = NSPredicate(format: "toTweets.tweetText contains[c] %@", mentions)
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? fetchedResultsController?.performFetch()
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetersRI", for: indexPath)
        if let user = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = user.handle
            let tweetCount = tweetCountWithMentionBy(user)
            cell.detailTextLabel?.text = "\(tweetCount) tweet\((tweetCount == 1) ? "": "s")"
        }
        return cell
    }
    
    private func tweetCountWithMentionBy(_ twitterUser: TwitterUser) -> Int {
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "tweetText contains[c] %@ and toTwitterUser = %@", mention!, twitterUser)
        return (try? twitterUser.managedObjectContext!.count(for: request)) ?? 0
    }
}

extension SmashTweeterTableViewController
{
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return fetchedResultsController?.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {   if let sections = fetchedResultsController?.sections, sections.count > 0 {
        return sections[section].name
    } else {
        return nil
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]?
    {
        return fetchedResultsController?.sectionIndexTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int
    {
        return fetchedResultsController?.section(forSectionIndexTitle: title, at: index) ?? 0
    }
    
}
