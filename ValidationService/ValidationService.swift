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
    static let other = ValidationOptions(rawValue: 1 << 2)
}

final class ValidationService {
    private init() {
    }
    
    static let shared = ValidationService()
    
    var forbidEmoji = true
    var shouldTream = false
    var allowSpacesInside = false
    
    func validate(_ string: String?,
                         with options: ValidationOptions?,
                         maxLength: Int,
                         minLength: Int = 1) -> Bool {
        assert(minLength <= maxLength, "Minimal length of string can not be greater then Maximum length")
        assert(minLength >= 0 && maxLength >= 0, "Minamal and Maximum length must be greater or equal zero")
        
        guard var unwrappedString = string else {
                return false
        }
        
        if shouldTream {
            unwrappedString = unwrappedString.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if !(minLength...maxLength ~= unwrappedString.characters.count)  {
            return false
        }
        
        if forbidEmoji {
            if unwrappedString.containsEmoji {
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
        
        if allowSpacesInside {
            suitableSymbolsCharacterSet.insert(charactersIn: " ")
        }
        
        let notSuitableCharacterSet = suitableSymbolsCharacterSet.inverted
        
        if unwrappedString.rangeOfCharacter(from: notSuitableCharacterSet) != nil {
            return false
        }
        
        return true
    }
    
    func isEmail(string: String?) -> Bool {
        guard let unwrappedString = string else {
            return false
        }
        
        let regex = try? NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: [.caseInsensitive])
        
        return regex?.firstMatch(in: unwrappedString, options:[], range: NSMakeRange(0, unwrappedString.utf16.count)) != nil
    }
}
