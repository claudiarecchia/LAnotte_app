//
//  TextView.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 01/02/22.
//

import SwiftUI

struct TextView: UIViewRepresentable {
	var text: String
	
	func makeUIView(context: Context) -> UITextView {
		let textView = UITextView()
		textView.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
		textView.textAlignment = .justified
		return textView
	}
	
	func updateUIView(_ uiView: UITextView, context: Context) {
		uiView.text = text
	}
}
