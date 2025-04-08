//
//  ShelfListViewModel.swift
//  ShelfSnapshot
//
//  Created by Leandro Sousa on 03/04/2025.
//

import Foundation
import SwiftData

@Observable
class ShelfListViewModel {
	enum SortOption {
		case dateNewestFirst
		case dateOldestFirst
		case storeName
	}

	@MainActor
	private(set) var snapshots: [ShelfSnapshot] = []
	@MainActor var searchText: String = ""
	@MainActor var selectedTag: String? = nil
	@MainActor var sortOption: SortOption = .dateNewestFirst
	@MainActor var selectedProduct: String? = nil

	private var context: ModelContext

	init(context: ModelContext) {
		self.context = context
	}

	@MainActor
	func loadSnapshots() {
		var descriptor = FetchDescriptor<ShelfSnapshot>()

		switch sortOption {
		case .dateNewestFirst:
			descriptor.sortBy = [SortDescriptor(\.dateCaptured, order: .reverse)]
		case .dateOldestFirst:
			descriptor.sortBy = [SortDescriptor(\.dateCaptured, order: .forward)]
		case .storeName:
			descriptor.sortBy = [SortDescriptor(\.storeLocation)]
		}

		do {
			let allSnapshots = try context.fetch(descriptor)

			let filtered = allSnapshots.filter { snapshot in
				let matchesSearch = searchText.isEmpty
				|| snapshot.storeLocation.localizedCaseInsensitiveContains(searchText)
				|| snapshot.tags.contains(where: { $0.localizedCaseInsensitiveContains(searchText) })
				|| snapshot.recognizedProducts.contains { product in
					product.name.localizedCaseInsensitiveContains(searchText)
				}

				let matchesTag = selectedTag == nil || snapshot.tags.contains(selectedTag!)
				let matchesProduct = selectedProduct == nil || snapshot.recognizedProducts.contains {
					$0.name.localizedCaseInsensitiveContains(selectedProduct!)
				}

				return matchesSearch && matchesTag && matchesProduct
			}

			snapshots = filtered
		} catch {
			print("Failed to fetch snapshots: \(error)")
			snapshots = []
		}
	}

	@MainActor
	func delete(_ snapshot: ShelfSnapshot) {
		context.delete(snapshot)
		try? context.save()
		loadSnapshots()
	}

	@MainActor
	func availableTags() -> [String] {
		let allTags = snapshots.flatMap { $0.tags }
		return Array(Set(allTags)).sorted()
	}

	@MainActor
	func availableRecognizedProducts() -> [String] {
		let allProductNames = snapshots.flatMap { $0.recognizedProducts.map { $0.name } }
		return Array(Set(allProductNames)).sorted()
	}
}
