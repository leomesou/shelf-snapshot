//
//  ShelfSnapshotApp.swift
//  ShelfSnapshot
//
//  Created by Leandro Sousa on 02/04/2025.
//

import SwiftUI
import SwiftData

@main
struct ShelfSnapshotApp: App {

	var body: some Scene {
		WindowGroup {
			ShelfListView()
		}
		.modelContainer(SwiftDataManager.shared.modelContainer)
	}
}
