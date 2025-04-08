//
//  View+Extensions.swift
//  ShelfSnapshot
//
//  Created by Leandro Sousa on 06/04/2025.
//

import SwiftUI

extension View {
	func dismissKeyboardOnTap() -> some View {
		self.modifier(DismissKeyboardOnTapModifier())
	}
}
