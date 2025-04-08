//
//  AppStrings.swift
//  ShelfSnapshot
//
//  Created by Leandro Sousa on 08/04/2025.
//

import Foundation

enum Strings {

	enum ShelfList {
		enum Text {
			static let title = "Shelf Snapshots"
			static let sortNewest = "Newest First"
			static let sortOldest = "Oldest First"
			static let sortByStore = "Store Name"
			static let searchPlaceholder = "Search by store, tag, or product"
			static let allTags = "All Tags"
			static let allProducts = "All Products"
		}

		enum ImageName {
			static let cameraIcon = "camera.fill"
			static let sortIcon = "arrow.up.arrow.down.circle"
			static let searchIcon = "magnifyingglass"
			static let tagIcon = "tag"
			static let productIcon = "cube.box"
		}
	}

	enum ShelfDetail {
		enum Text {
			static let title = "Shelf Details"
			static let store = "Store:"
			static let capturedOn = "Captured on:"
			static let addTagPlaceholder = "Add Tag"
			static let addTagButton = "Add"
			static let recognizeButton = "Recognize Products"
			static let recognizedProductsTitle = "Recognized Products:"
			static let recognizeErrorTitle = "Recognition Error"
			static let recognizeErrorDismiss = "OK"
			static let recognizeLoadError = "Failed to load image for recognition."
			static let recognizeUnknownError = "An unknown error occurred during image recognition."
		}

		enum ImageName {
			static let recognizeIcon = "text.magnifyingglass"
		}
	}

	enum Camera {
		enum Text {
			static let storeLocationPlaceholder = "Enter Store Location"
			static let usePhoto = "Use Photo"
			static let retakePhoto = "Retake"
		}

		enum ImageName {
			static let mockShelf = "mockShelf"
			static let flashOn = "bolt.fill"
			static let flashOff = "bolt.slash"
			static let switchCamera = "arrow.triangle.2.circlepath.camera"
		}
	}
}
