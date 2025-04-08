//
//  ImageRecognitionService.swift
//  ShelfSnapshot
//
//  Created by Leandro Sousa on 03/04/2025.
//

import Vision
import UIKit

class ImageRecognitionService {
	func recognizeProducts(from image: UIImage, completion: @escaping ([String]?, String?) -> Void) {
		guard let ciImage = CIImage(image: image) else { return }
		let handler = VNImageRequestHandler(ciImage: ciImage)
		let request = VNRecognizeTextRequest { request, _ in
			let results = request.results as? [VNRecognizedTextObservation]
			let recognizedTexts = results?.compactMap { $0.topCandidates(1).first?.string } ?? []
			completion(recognizedTexts, nil)
		}

		do {
			try handler.perform([request])
		} catch {
			completion(nil, error.localizedDescription)
		}
	}
}
