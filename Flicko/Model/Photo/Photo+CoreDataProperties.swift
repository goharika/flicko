//
//  Photo+CoreDataProperties.swift
//  Flicko
//
//  Created by Gohar on 10/11/2018.
//  Copyright © 2018 AG. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var photoID: String?
    @NSManaged public var title: String?
    @NSManaged public var mediaURL: String?
    @NSManaged public var comments: NSSet?

}

// MARK: Generated accessors for comments
extension Photo {

    @objc(addCommentsObject:)
    @NSManaged public func addToComments(_ value: Comments)

    @objc(removeCommentsObject:)
    @NSManaged public func removeFromComments(_ value: Comments)

    @objc(addComments:)
    @NSManaged public func addToComments(_ values: NSSet)

    @objc(removeComments:)
    @NSManaged public func removeFromComments(_ values: NSSet)

}
