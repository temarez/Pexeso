//
//  Difficulty.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 01.02.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import Foundation

struct Difficulty {
    var numberOfCardPairs: Int = 1

    func getRowsCollomnsNumber() -> (shortSide: Int, longSide: Int) {
        switch numberOfCardPairs {
        case 1: return (shortSide: 1, longSide: 2)
        case 4: return (shortSide: 2, longSide: 4)
        case 6: return (shortSide: 3, longSide: 4)
        case 8: return (shortSide: 4, longSide: 4)
        case 10: return (shortSide: 4, longSide: 5)
        case 12: return (shortSide: 4, longSide: 6)
        default:
            let short = Int(Float(numberOfCardPairs*2).squareRoot())
            let long = Int((numberOfCardPairs*2) / short) + 1
            return (shortSide: short, longSide: long)
        }
    }

}
