//
//  CameraView.swift
//  ShelfSnapshot
//
//  Created by Leandro Sousa on 03/04/2025.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext
	@StateObject private var cameraVM = CameraViewModel()

	var body: some View {
		ZStack {
			CameraPreview(session: cameraVM.captureSession)
				.edgesIgnoringSafeArea(.all)

			VStack {
				HStack {
					Spacer()

					Button(action: {
						cameraVM.toggleFlash()
					}) {
						Image(systemName: cameraVM.isFlashOn ? Strings.Camera.ImageName.flashOn : Strings.Camera.ImageName.flashOff)
							.font(.title2)
							.padding()
							.background(Color.white.opacity(0.5))
							.clipShape(Circle())
					}
					.padding()

					Button(action: {
						cameraVM.switchCamera()
					}) {
						Image(systemName: Strings.Camera.ImageName.switchCamera)
							.font(.title2)
							.padding()
							.background(Color.white.opacity(0.5))
							.clipShape(Circle())
					}
					.padding(.trailing)
				}
				.frame(maxWidth: .infinity, alignment: .trailing)

				Spacer()

				Button(action: {
					cameraVM.capturePhoto()
				}) {
					Circle()
						.fill(Color.white)
						.frame(width: 70, height: 70)
						.shadow(radius: 5)
				}
				.padding()
			}
		}
		.onAppear {
			cameraVM.startSession()
		}
		.onDisappear {
			cameraVM.stopSession()
		}
		.fullScreenCover(isPresented: $cameraVM.showPreview) {
			ZStack {
				VisualEffectBlur()
					.edgesIgnoringSafeArea(.all)
					.transition(.opacity)

				if let image = cameraVM.previewImage {
					VStack(spacing: 16) {
						Image(uiImage: image)
							.resizable()
							.scaledToFit()
							.cornerRadius(12)
							.shadow(radius: 8)

						TextField(Strings.Camera.Text.storeLocationPlaceholder, text: $cameraVM.storeLocation)
							.textFieldStyle(.roundedBorder)
							.padding()
							.autocapitalization(.words)

//						if !cameraVM.previousLocations.isEmpty {
//							ScrollView {
//								VStack(alignment: .leading) {
//									Text("Suggested Locations:")
//										.font(.headline)
//										.padding(.bottom, 4)
//
//									ForEach(cameraVM.previousLocations, id: \.self) { location in
//										Button(action: {
//											cameraVM.storeLocation = location
//										}) {
//											Text(location)
//												.padding()
//												.background(Color.gray.opacity(0.2))
//												.cornerRadius(8)
//										}
//									}
//								}
//								.padding()
//							}
//						}

						Button(Strings.Camera.Text.usePhoto) {
							let newSnapshot = ShelfSnapshot(
								imageData: image.jpegData(compressionQuality: 1.0) ?? Data(),
								storeLocation: cameraVM.storeLocation,
								dateCaptured: Date()
							)
							modelContext.insert(newSnapshot)
							dismiss()
						}
						.buttonStyle(.borderedProminent)

						Button(Strings.Camera.Text.retakePhoto) {
							withAnimation {
								cameraVM.showPreview = false
							}
						}
						.buttonStyle(.bordered)
					}
					.padding()
					.transition(.scale)
				}
			}
		}
	}
}
