//
//  Favorite+CoreDataProperties.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 28/06/21.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var posterUrl: String?
    @NSManaged public var summary: String?

}

extension Favorite : Identifiable {

}
