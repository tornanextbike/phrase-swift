//
//  NSMutableAttributedStringExtensions.swift
//  Nimble
//
//  Created by Jan Meier on 09.12.19.
//

import Foundation

extension NSMutableAttributedString {
    
    func replace(start: Int, end: Int, toReplaceWith: String) {
        let range = NSMakeRange(start, end - start)
        self.deleteCharacters(in: range)
        let mutableString = NSAttributedString(string: toReplaceWith)
        self.insert(mutableString, at: start)
    }
}
