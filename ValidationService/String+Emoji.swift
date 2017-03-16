//
// 
//
//  Created by Bohdan Savych on 1/27/17.
//  Copyright © 2017 Bohdan Savych. All rights reserved.
//

import Foundation

extension String {
    struct EmojiRanges {
        static let emoticons = 0x1F600...0x1F64F
        static let miscSymbolsAndPictographs = 0x1F300...0x1F5FF
        static let transportAndMap = 0x1F680...0x1F6FF
        static let miscSymbols = 0x2600...0x26FF
        static let dingbats = 0x2700...0x27BF
        static let variationSelectors = 0xFE00...0xFE0F
        
        static let all = [variationSelectors, dingbats, miscSymbols, transportAndMap, miscSymbolsAndPictographs, emoticons]
    }
    
    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            for range in EmojiRanges.all {
                if range.contains(Int(scalar.value)) {
                    return true
                }
            }
        }
        
        return false
    }
}
