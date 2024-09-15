//
//  Item.swift
//  tabber
//
//  Created by Armaan Bassi on 9/14/24.
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
