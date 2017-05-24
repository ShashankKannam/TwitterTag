//
//  TweetTableViewCell.swift
//  TwitterTag
//
//  Created by shashank kannam on 5/24/17.
//  Copyright © 2017 developer. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var created: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tweetDescription: UILabel!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        name.text = tweet?.user.name
        tweetDescription.text = tweet?.text
        
        if let imageURL = tweet?.user.profileImageURL {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        self.profileImage.image = UIImage(data: imageData)
                    }
                }
            }
        }
        
        if let create = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(create) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            created.text = formatter.string(from: create)
        } else {
            created.text = nil
        }
    }

}
