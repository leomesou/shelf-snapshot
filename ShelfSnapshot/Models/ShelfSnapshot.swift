//
//  ShelfSnapshot.swift
//  ShelfSnapshot
//
//  Created by Leandro Sousa on 03/04/2025.
//

import Foundation
import SwiftData

@Model
class ShelfSnapshot {
	private(set) var id: UUID
	var imageData: Data
	var storeLocation: String
	var dateCaptured: Date
	var tags: [String]
	var recognizedProducts: [RecognizedProduct]

	init(imageData: Data, storeLocation: String, dateCaptured: Date, tags: [String] = []) {
		self.id = UUID()
		self.imageData = imageData
		self.storeLocation = storeLocation
		self.dateCaptured = dateCaptured
		self.tags = tags
		self.recognizedProducts = []
	}
}
