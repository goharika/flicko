//
//  DBManager.swift
//  Flicko
//
//  Created by Gohar on 10/11/2018.
//  Copyright © 2018 AG. All rights reserved.
//

import UIKit
import CoreData

class DBManager {
    
    class var shared: DBManager {
        struct Singleton {
            static let instance = DBManager()
        }
        return Singleton.instance
    }
    
    private func createPhotoEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let photoEntity = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context) as? Photo {
            photoEntity.title = dictionary["title"] as? String
            photoEntity.photoID = dictionary["id"] as? String
            photoEntity.mediaURL = dictionary["url_m"] as? String
            return photoEntity
        }
        return nil
    }
    
     func createCommentEntityFrom(text: String) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let commentEntity = NSEntityDescription.insertNewObject(forEntityName: "Comments", into: context) as? Comments {
            commentEntity.commentText = text
            return commentEntity
        }
        return nil
    }
    
    func saveCommentInCoreData(comment: String) {
        _ = createCommentEntityFrom(text: comment)
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    func saveInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{self.createPhotoEntityFrom(dictionary: $0)}
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Photo.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
}
