//
//  ShelfListView.swift
//  ShelfSnapshot
//
//  Created by Leandro Sousa on 03/04/2025.
//

import SwiftUI
import SwiftData

struct ShelfListView: View {
	@Environment(\.modelContext) private var modelContext
	@State private var viewModel: ShelfListViewModel? = nil
	@State private var showTagFilter = false
	@State private var showProductFilter = false
	@State private var isCameraViewActive = false

	var body: some View {
		NavigationStack {
			ZStack {
				contentBody
			}
			.dismissKeyboardOnTap()
			.navigationTitle(Strings.ShelfList.Text.title)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button(action: {
						isCameraViewActive.toggle()
					}) {
						Image(systemName: Strings.ShelfList.ImageName.cameraIcon)
					}
				}

				ToolbarItem(placement: .navigationBarTrailing) {
					Menu {
						Button(Strings.ShelfList.Text.sortNewest) {
							viewModel?.sortOption = .dateNewestFirst
							Task { @MainActor in viewModel?.loadSnapshots() }
						}
						Button(Strings.ShelfList.Text.sortOldest) {
							viewModel?.sortOption = .dateOldestFirst
							Task { @MainActor in viewModel?.loadSnapshots() }
						}
						Button(Strings.ShelfList.Text.sortByStore) {
							viewModel?.sortOption = .storeName
							Task { @MainActor in viewModel?.loadSnapshots() }
						}
					} label: {
						Image(systemName: Strings.ShelfList.ImageName.sortIcon)
					}
				}
			}
			.navigationDestination(isPresented: $isCameraViewActive) {
				CameraView()
			}
		}
		.onAppear {
			if viewModel == nil {
				viewModel = ShelfListViewModel(context: modelContext)
			}
			Task { @MainActor in viewModel?.loadSnapshots() }
		}
		.onChange(of: isCameraViewActive) {
			if !isCameraViewActive {
				Task { @MainActor in viewModel?.loadSnapshots() }
			}
		}
	}

	var contentBody: some View {
		VStack(spacing: 12) {
			if let viewModel = viewModel {
				HStack {
					HStack {
						Image(systemName: Strings.ShelfList.ImageName.searchIcon)
							.foregroundColor(.gray)

						TextField(Strings.ShelfList.Text.searchPlaceholder, text: Binding(
							get: { viewModel.searchText },
							set: { newValue in
								viewModel.searchText = newValue
								Task { @MainActor in
									viewModel.loadSnapshots()
								}
							}
						))
					}
					.padding(8)
					.background(Color(.systemGray6))
					.cornerRadius(10)

					Menu {
						Button(Strings.ShelfList.Text.allTags) {
							viewModel.selectedTag = nil
							Task { @MainActor in viewModel.loadSnapshots() }
						}
						ForEach(viewModel.availableTags(), id: \.self) { tag in
							Button("#\(tag)") {
								viewModel.selectedTag = tag
								Task { @MainActor in viewModel.loadSnapshots() }
							}
						}
					} label: {
						Image(systemName: Strings.ShelfList.ImageName.tagIcon)
							.padding(8)
					}

					Menu {
						Button(Strings.ShelfList.Text.allProducts) {
							viewModel.selectedProduct = nil
							Task { @MainActor in viewModel.loadSnapshots() }
						}
						ForEach(viewModel.availableRecognizedProducts(), id: \.self) { product in
							Button(product) {
								viewModel.selectedProduct = product
								Task { @MainActor in viewModel.loadSnapshots() }
							}
						}
					} label: {
						Image(systemName: Strings.ShelfList.ImageName.productIcon)
							.padding(8)
					}
				}
				.padding(.horizontal)
			}

			ScrollView {
				if let viewModel = viewModel {
					LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 10) {
						ForEach(viewModel.snapshots) { snapshot in
							NavigationLink(destination: ShelfDetailView(snapshot: snapshot)) {
								Image(uiImage: UIImage(data: snapshot.imageData) ?? UIImage())
									.resizable()
									.scaledToFill()
									.frame(width: 120, height: 120)
									.clipped()
									.cornerRadius(10)
							}
						}
					}
					.padding()
				}
			}
		}
	}
}
