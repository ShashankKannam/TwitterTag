//
//  TweetTableViewController.swift
//  TwitterTag
//
//  Created by shashank kannam on 5/15/17.
//  Copyright © 2017 developer. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        searchForTweets()
    }
    
    private var tweets = [Array<Twitter.Tweet>]()
    
    private var lastTwitterRequest: Twitter.Request?
    
    var searchText: String? {
        didSet {
            searchTextField.text = searchText
            searchTextField.resignFirstResponder()
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            title = searchText
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchText = searchTextField.text
        }
        return true
    }
    
    func insertTweets(newTweets: [Twitter.Tweet]) {
        tweets.insert(newTweets, at: 0)
        tableView.insertSections([0], with: .fade)
    }
    
    private func searchForTweets() {
        if let request = lastTwitterRequest?.newer ?? getTwitterRequest() {
            lastTwitterRequest = request
            request.fetchTweets{ [weak self] newTweets in
                if request == self?.lastTwitterRequest {
                    DispatchQueue.main.async {
                        self?.insertTweets(newTweets: newTweets)
                        self?.refreshControl?.endRefreshing()
                    }
                }
            }
        } else {
            refreshControl?.endRefreshing()
        }
    }
    
    private func getTwitterRequest() -> Twitter.Request? {
        if let queryText = searchText, !queryText.isEmpty {
            return Twitter.Request(search: queryText, count: 100)
        }
        return nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TweetRI", for: indexPath) as? TweetTableViewCell else { return UITableViewCell() }
        let tweet = tweets[indexPath.section][indexPath.row]
        cell.tweet = tweet
        return cell
    }
 
}
