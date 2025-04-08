//
//  SwiftDataManager.swift
//  ShelfSnapshot
//
//  Created by Leandro Sousa on 03/04/2025.
//

import SwiftData

class SwiftDataManager {
	static let shared = SwiftDataManager()

	let modelContainer: ModelContainer

	private init() {
		let schema = Schema([ShelfSnapshot.self])
		let configuration = ModelConfiguration(schema: schema)
		do {
			self.modelContainer = try ModelContainer(for: schema, configurations: [configuration])
		} catch {
			fatalError("Could not create ModelContainer: \(error)")
		}
	}
}
