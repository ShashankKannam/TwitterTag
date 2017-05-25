//
//  Tweet+CoreDataProperties.swift
//  TwitterTag
//
//  Created by shashank kannam on 5/24/17.
//  Copyright © 2017 developer. All rights reserved.
//

import Foundation
import CoreData


extension Tweet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tweet> {
        return NSFetchRequest<Tweet>(entityName: "Tweet")
    }
    
    @NSManaged public var created: NSDate?
    @NSManaged public var tweetText: String?
    @NSManaged public var uniqueID: String?
    @NSManaged public var toTwitterUser: TwitterUser?

}
