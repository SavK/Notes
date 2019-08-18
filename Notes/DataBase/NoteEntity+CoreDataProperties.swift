//
//  NoteEntity+CoreDataProperties.swift
//  
//
//  Created by Savonevich Constantine on 8/18/19.
//
//

import Foundation
import CoreData


extension NoteEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteEntity> {
        return NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
    }

    @NSManaged public var color: Data?
    @NSManaged public var content: String?
    @NSManaged public var importance: String?
    @NSManaged public var selfDestructionDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var uid: String

}
