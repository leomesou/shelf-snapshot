//
//  CameraPreview.swift
//  ShelfSnapshot
//
//  Created by Leandro Sousa on 03/04/2025.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
	let session: AVCaptureSession

	func makeUIView(context: Context) -> UIView {
		let view = UIView(frame: UIScreen.main.bounds)
		let previewLayer = AVCaptureVideoPreviewLayer(session: session)

		previewLayer.videoGravity = .resizeAspectFill
		previewLayer.frame = view.bounds

		view.layer.addSublayer(previewLayer)
		return view
	}

	func updateUIView(_ uiView: UIView, context: Context) {
		if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
			previewLayer.session = session
		}
	}
}
