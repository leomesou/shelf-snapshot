//
//  ShelfDetailViewModel.swift
//  ShelfSnapshot
//
//  Created by Leandro Sousa on 03/04/2025.
//

import SwiftUI

class ShelfDetailViewModel: ObservableObject {
	@Published var recognizedProducts: [String] = []
	@Published var recognitionError: String? = nil
	@Published var newTag: String = ""

	let snapshot: ShelfSnapshot
	private let imageRecognitionService = ImageRecognitionService()

	init(snapshot: ShelfSnapshot) {
		self.snapshot = snapshot
	}

	func recognizeProducts() {
		guard let image = UIImage(data: snapshot.imageData) else {
			recognitionError = Strings.ShelfDetail.Text.recognizeLoadError
			return
		}

		imageRecognitionService.recognizeProducts(from: image) { recognizedProducts, error in
			DispatchQueue.main.async {
				if let recognizedProducts = recognizedProducts {
					self.recognizedProducts = recognizedProducts
				} else {
					self.recognitionError = error ?? Strings.ShelfDetail.Text.recognizeUnknownError
				}
			}
		}
	}

	func addTag() {
		if !newTag.isEmpty {
			snapshot.tags.append(newTag)
			newTag = ""
		}
	}
}
