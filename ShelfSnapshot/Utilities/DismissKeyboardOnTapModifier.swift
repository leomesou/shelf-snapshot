//
//  DismissKeyboardOnTapModifier.swift
//  ShelfSnapshot
//
//  Created by Leandro Sousa on 06/04/2025.
//

import SwiftUI

struct DismissKeyboardOnTapModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.background(
				Color.clear
					.contentShape(Rectangle())
					.onTapGesture {
						UIApplication.shared.sendAction(
							#selector(UIResponder.resignFirstResponder),
							to: nil,
							from: nil,
							for: nil
						)
					}
			)
	}
}
