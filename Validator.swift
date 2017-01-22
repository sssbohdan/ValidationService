//
//  Validator.swift
//  Vyykn
//
//  Created by Bohdan Savych on 1/17/17.
//  Copyright © 2017 Bohdan Savych. All rights reserved.
//

import UIKit

struct ValidationOptions : OptionSet {
    let rawValue: Int
    
    static let digits = ValidationOptions(rawValue: 1 << 0)
    static let letters = ValidationOptions(rawValue: 1 << 1)
    static let other = ValidationOptions(rawValue: 1 << 2) //idk how to name this option 🙂
}

final class Validator {
    static func validate(string: String?,
                         with options: ValidationOptions?,
                         maxLength: Int,
                         minLength: Int = 1,
                         shouldBeSameAsTheMaxRange: Bool = false) -> Bool {
        guard let unwrappedString = string,
            unwrappedString.isEmpty == false,
            unwrappedString.characters.count >= minLength  else {
                return false
        }
        
        if shouldBeSameAsTheMaxRange {
            if unwrappedString.characters.count != maxLength {
                return false
            }
        } else {
            if unwrappedString.characters.count > maxLength {
                return false
            }
        }
        
        guard let unwrappedOptions = options, !unwrappedOptions.isEmpty else {
            return true
        }
        
        var suitableSymbolsCharacterSet = CharacterSet()
        
        if unwrappedOptions.contains(.digits) {
            suitableSymbolsCharacterSet = suitableSymbolsCharacterSet.union(.decimalDigits)
        }
        
        if unwrappedOptions.contains(.letters) {
            suitableSymbolsCharacterSet = suitableSymbolsCharacterSet.union(.letters)
        }
        
        if unwrappedOptions.contains(.other) {
            let digitsAndLettersCharacterSet = CharacterSet.decimalDigits.union(CharacterSet.letters)
            suitableSymbolsCharacterSet = suitableSymbolsCharacterSet.union(digitsAndLettersCharacterSet.inverted)
        }
        
        let notSuitableCharacterSet = suitableSymbolsCharacterSet.inverted
        
        if unwrappedString.rangeOfCharacter(from: notSuitableCharacterSet) != nil {
            return false
        }
        
        return true
    }
    
    static func isEmail(string: String?) -> Bool {
        guard let unwrappedString = string else {
            return false
        }
        
        let regex = try? NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: [.caseInsensitive])
        
        return regex?.firstMatch(in: unwrappedString, options:[], range: NSMakeRange(0, unwrappedString.utf16.count)) != nil
    }
}
