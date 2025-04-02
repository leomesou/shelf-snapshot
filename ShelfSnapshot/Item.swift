//
//  Item.swift
//  ShelfSnapshot
//
//  Created by Leandro Sousa on 02/04/2025.
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
