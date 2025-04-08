//
//  RecognizedProduct.swift
//  ShelfSnapshot
//
//  Created by Leandro Sousa on 03/04/2025.
//

import Foundation
import SwiftData

@Model
class RecognizedProduct {
	private(set) var id: UUID
	var name: String
	var price: Double?
	var stockLevel: Int?

	init(name: String, price: Double? = nil, stockLevel: Int? = nil) {
		self.id = UUID()
		self.name = name
		self.price = price
		self.stockLevel = stockLevel
	}
}
