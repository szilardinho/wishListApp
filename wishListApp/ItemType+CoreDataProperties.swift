//
//  ItemType+CoreDataProperties.swift
//  wishListApp
//
//  Created by Szi Gabor on 4/8/17.
//  Copyright © 2017 Szi. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType");
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
