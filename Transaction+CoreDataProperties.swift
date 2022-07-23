//
//  Transaction+CoreDataProperties.swift
//  My accountant
//
//  Created by Yuliya Lapenak on 7/4/22.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: Float
    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var expense: Bool
    @NSManaged public var note: String?

}

extension Transaction : Identifiable {

}
