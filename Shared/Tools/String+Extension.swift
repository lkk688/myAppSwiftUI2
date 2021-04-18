//
//  String+Extension.swift
//  myAppSwiftUI2 (iOS)
//
//  Created by Kaikai Liu on 4/18/21.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
