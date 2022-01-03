//
//  GrowingButton.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 03/01/22.
//

import SwiftUI

struct GrowingButton: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.scaleEffect(configuration.isPressed ? 1.2 : 1)
			.animation(.easeOut(duration: 0.2), value: configuration.isPressed)
	}
}
