//
//  TwitterUser+CoreDataProperties.swift
//  TwitterTag
//
//  Created by shashank kannam on 5/24/17.
//  Copyright © 2017 developer. All rights reserved.
//

import Foundation
import CoreData


extension TwitterUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TwitterUser> {
        return NSFetchRequest<TwitterUser>(entityName: "TwitterUser")
    }

    @NSManaged public var handle: String?
    @NSManaged public var name: String?
    @NSManaged public var toTweets: NSSet?

}

// MARK: Generated accessors for toTweets
extension TwitterUser {

    @objc(addToTweetsObject:)
    @NSManaged public func addToToTweets(_ value: Tweet)

    @objc(removeToTweetsObject:)
    @NSManaged public func removeFromToTweets(_ value: Tweet)

    @objc(addToTweets:)
    @NSManaged public func addToToTweets(_ values: NSSet)

    @objc(removeToTweets:)
    @NSManaged public func removeFromToTweets(_ values: NSSet)

}
