//
//  CardsSizeCalculator.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 29.01.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import UIKit

enum RectSide {
    case height
    case width
}

extension CGSize {
    
    func longSide() -> RectSide {
        if(self.height >= self.width) {
            return RectSide.height
        }
        else {
            return RectSide.width
        }
    }
    
    func shortSide() -> RectSide {
        var shortSide = RectSide.width
        let longSide = self.longSide()
        switch longSide {
        case .height:
            shortSide = RectSide.width
        case .width:
            shortSide = RectSide.height
        }
        return shortSide
    }
    
    private func sideSize(side: RectSide) -> CGFloat {
        switch side {
        case .height:
            return self.height
        case .width:
            return self.width
        }
    }
    
    func longSideSize() -> CGFloat {
        return sideSize(side: longSide())
    }
    
    func shortSideSize() -> CGFloat {
        return sideSize(side: shortSide())
    }
    
    /*
    /// This should scale the size down if it is more then maxSize or otherwise leave it unchanged
    func fitToMaxSize(maxSize: CGSize) {
        var ratioHeight: CGFloat = self.height / maxSize.height
        var ratioWidth: CGFloat = self.width / maxSize.width
    }
 */
    
}

struct CardSizeConstants {
    static var cardSizeMax = CGSize(width: 1024, height: 1024)
    static var minSpacingBetweenCards = 10 // TODO: implement
    static var aspectRatio: Double = 1.0 // TODO: implement
}

class CardSizeCalculator {
    public var collectionViewSections: CollectionViewSections
    
    public func getCardSize(collectionViewFrameSize: CGSize, numberOfPairs: Int) -> CGSize {
        let numberOfCards = numberOfPairs * 2
        let collectionViewShortSideSize = collectionViewFrameSize.shortSideSize()
        let collectionViewLongSideSize = collectionViewFrameSize.longSideSize()

        var cardShortSideSize = CGFloat(1)
        var cardLongSideSize = CGFloat(1)
        
        let rowsCollomnsNumber = Difficulty(numberOfPairs).getRowsCollomnsNumber()
        
        // Calculate the maximal possible card size that will fit (without aspect ratio and spacings between cards)
        cardShortSideSize = collectionViewShortSideSize / CGFloat(rowsCollomnsNumber.shortSide)
        cardLongSideSize = collectionViewLongSideSize / CGFloat(rowsCollomnsNumber.longSide)
        
        cardShortSideSize = cardShortSideSize - 20
        cardLongSideSize = cardLongSideSize - 20
        
        let calculatedCardSize = CGSize(width: cardShortSideSize, height: cardLongSideSize)
        /*
        if(collectionViewFrameSize.width == 716.0) { // this is for landscape orientation
            calculatedCardSize = CGSize(width: 100, height: 100)
        } else if(collectionViewFrameSize.width == 394.0) { // this is for portrait orientation
            calculatedCardSize = CGSize(width: 186, height: 186)
        }*/
        //print("CalculatedCardSize: \(calculatedCardSize)")
        return calculatedCardSize
    }
    
    init() {
        collectionViewSections = CollectionViewSections()
    }
    
}
