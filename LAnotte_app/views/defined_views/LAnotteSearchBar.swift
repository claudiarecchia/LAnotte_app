//
//  LAnotteSearchBar.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 21/12/21.
//

import SwiftUI


struct LAnotteSearchBar: View {
	@Binding var text: String
	@State private var isEditing = false
		
	var placeholderText = ""
	
	var body: some View {
		HStack {
 
			TextField(placeholderText, text: $text)
				.padding(7)
				.padding(.horizontal, 25)
				.background(Color(.systemGray6))
				.cornerRadius(8)
				.padding(.horizontal, 10)
				.onTapGesture {
					self.isEditing = true
				}
				.overlay(
					HStack {
						Image(systemName: "magnifyingglass")
							.foregroundColor(.gray)
							.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
							.padding(.leading, 15)
				 
						if isEditing {
							Button(action: {
								self.isEditing = false
								self.text = ""
								// Dismiss the keyboard
								UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
							}) {
								Image(systemName: "multiply.circle.fill")
									.foregroundColor(.gray)
									.padding(.trailing, 15)
							}
						}
					}
				)
		}
		
	}
}

struct LAnotteSearchBar_Previews: PreviewProvider {
    static var previews: some View {
		LAnotteSearchBar(text: .constant(""))
    }
}
