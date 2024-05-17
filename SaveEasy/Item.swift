//
//  Item.swift
//  SaveEasy
//
//  Created by Jack Hodges on 17/5/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
