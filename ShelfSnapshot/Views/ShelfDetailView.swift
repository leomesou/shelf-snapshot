//
//  ShelfDetailView.swift
//  ShelfSnapshot
//
//  Created by Leandro Sousa on 03/04/2025.
//

import SwiftUI

struct ShelfDetailView: View {
	@ObservedObject var viewModel: ShelfDetailViewModel

	init(snapshot: ShelfSnapshot) {
		self.viewModel = ShelfDetailViewModel(snapshot: snapshot)
	}

	var body: some View {
		VStack {
			Image(uiImage: UIImage(data: viewModel.snapshot.imageData) ?? UIImage())
				.resizable()
				.scaledToFit()
				.frame(height: 300)
				.cornerRadius(12)

			Text([Strings.ShelfDetail.Text.store, viewModel.snapshot.storeLocation].joined(separator: " "))
				.font(.headline)

			Text([Strings.ShelfDetail.Text.capturedOn, viewModel.snapshot.dateCaptured.formatted(.dateTime)].joined(separator: " "))
				.font(.subheadline)
				.foregroundColor(.gray)

			HStack {
				TextField(Strings.ShelfDetail.Text.addTagPlaceholder, text: $viewModel.newTag)
					.textFieldStyle(RoundedBorderTextFieldStyle())

				Button(Strings.ShelfDetail.Text.addTagButton) {
					viewModel.addTag()
				}
				.buttonStyle(.bordered)
			}
			.padding()

			ScrollView(.horizontal) {
				HStack {
					ForEach(viewModel.snapshot.tags, id: \.self) { tag in
						Text("#\(tag)")
							.padding(8)
							.background(Color.blue.opacity(0.2))
							.cornerRadius(8)
					}
				}
			}

			Button(action: viewModel.recognizeProducts) {
				Label(Strings.ShelfDetail.Text.recognizeButton, systemImage: Strings.ShelfDetail.ImageName.recognizeIcon)
			}
			.buttonStyle(.borderedProminent)
			.padding()

			if !viewModel.recognizedProducts.isEmpty {
				Text(Strings.ShelfDetail.Text.recognizedProductsTitle)
					.font(.headline)
					.padding(.top)

				ForEach(viewModel.recognizedProducts, id: \.self) { product in
					Text(product)
						.padding(2)
				}
			}

			Spacer()
		}
		.padding()
		.navigationTitle(Strings.ShelfDetail.Text.title)
		.alert(Strings.ShelfDetail.Text.recognizeErrorTitle, isPresented: .constant(viewModel.recognitionError != nil), actions: {
			Button(Strings.ShelfDetail.Text.recognizeErrorDismiss, role: .cancel) {
				viewModel.recognitionError = nil
			}
		}, message: {
			Text(viewModel.recognitionError ?? Strings.ShelfDetail.Text.recognizeUnknownError)
		})
	}
}
