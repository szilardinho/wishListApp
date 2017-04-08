//
//  Item+CoreDataClass.swift
//  wishListApp
//
//  Created by Szi Gabor on 4/4/17.
//  Copyright © 2017 Szi. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

    public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate()
        
    }

}
