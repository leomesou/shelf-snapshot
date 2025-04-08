//
//  CameraViewModel.swift
//  ShelfSnapshot
//
//  Created by Leandro Sousa on 03/04/2025.
//

import SwiftUI
import SwiftData
import AVFoundation

class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
	let captureSession = AVCaptureSession()
	private let photoOutput = AVCapturePhotoOutput()
	private var videoDeviceInput: AVCaptureDeviceInput?

	@Published var capturedImage: UIImage?
	@Published var isFlashOn = false
	@Published var availableCameras: [AVCaptureDevice] = []
	@Published var currentCameraIndex = 0
	@Published var showPreview: Bool = false
	@Published var previewImage: UIImage?
	@Published var storeLocation: String = ""
	@Published var previousLocations: [String] = []

//	private var modelContext: ModelContext

	var isSimulator: Bool {
		#if targetEnvironment(simulator)
			return true
		#else
			return false
		#endif
	}

    override init() {
		super.init()
		setupSession()
	}

//	init(modelContext: ModelContext) {
//		self.modelContext = modelContext
//		super.init()
//		setupSession()
//		loadPreviousLocations()
//	}

	func setupSession() {
		if isSimulator {
			print("Camera not available in the simulator.")
			return
		}

		captureSession.beginConfiguration()
		captureSession.sessionPreset = .photo

		availableCameras = AVCaptureDevice.DiscoverySession(
			deviceTypes: [.builtInWideAngleCamera, .builtInUltraWideCamera],
			mediaType: .video,
			position: .back
		).devices

		guard let camera = availableCameras.first else {
			print("No cameras found.")
			return
		}

		do {
			let input = try AVCaptureDeviceInput(device: camera)
			if captureSession.canAddInput(input) {
				captureSession.addInput(input)
				videoDeviceInput = input
			}

			if captureSession.canAddOutput(photoOutput) {
				captureSession.addOutput(photoOutput)
			}
		} catch {
			print("Error setting up camera input: \(error)")
		}

		captureSession.commitConfiguration()
	}

	func switchCamera() {
		guard !isSimulator, !availableCameras.isEmpty else { return }

		currentCameraIndex = (currentCameraIndex + 1) % availableCameras.count
		let newCamera = availableCameras[currentCameraIndex]

		captureSession.beginConfiguration()

		if let currentInput = videoDeviceInput {
			captureSession.removeInput(currentInput)
		}

		do {
			let input = try AVCaptureDeviceInput(device: newCamera)
			if captureSession.canAddInput(input) {
				captureSession.addInput(input)
				videoDeviceInput = input
			}
		} catch {
			print("Error switching camera: \(error)")
		}

		captureSession.commitConfiguration()
	}

	func toggleFlash() {
		isFlashOn.toggle()
	}

	func startSession() {
		if isSimulator { return }

		DispatchQueue.global(qos: .background).async {
			self.captureSession.startRunning()
		}
	}

	func stopSession() {
		if isSimulator { return }

		captureSession.stopRunning()
	}

	func capturePhoto() {
		if isSimulator {
			print("Camera functionality not available in the simulator.")
			mockCapturePhoto()
			return
		}

		let settings = AVCapturePhotoSettings()
		settings.flashMode = isFlashOn ? .on : .off
		photoOutput.capturePhoto(with: settings, delegate: self)

		let generator = UIImpactFeedbackGenerator(style: .medium)
		generator.impactOccurred()
	}

	private func mockCapturePhoto() {
		guard let image = UIImage(named: Strings.Camera.ImageName.mockShelf) else {
			print("Mock image not found!")
			return
		}
		DispatchQueue.main.async {
			self.previewImage = image
			self.showPreview = true
		}
	}

	func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
		guard let data = photo.fileDataRepresentation(),
			  let image = UIImage(data: data) else { return }

		DispatchQueue.main.async {
			self.previewImage = image
			self.showPreview = true
		}
	}

//	func loadPreviousLocations() {
//		let fetchDescriptor = FetchDescriptor<ShelfSnapshot>()
//
//		do {
//			let snapshots = try modelContext.fetch(fetchDescriptor)
//			previousLocations = snapshots.map { $0.storeLocation }
//		} catch {
//			print("Failed to fetch previous snapshots: \(error)")
//		}
//	}
}
