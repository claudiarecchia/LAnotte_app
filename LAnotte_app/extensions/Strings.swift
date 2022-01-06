//
//  Strings.swift
//  LAnotte_app
//
//  Created by Claudia Recchia on 06/01/22.
//

import Foundation

extension String {

//   func contains(_ find: String) -> Bool{
//	 return self.range(of: find) != nil
//   }

   func containsIgnoringCase(_ find: String) -> Bool{
	 return self.range(of: find, options: .caseInsensitive) != nil
   }
 }
