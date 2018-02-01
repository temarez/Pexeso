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
    static var minSpacingBetweenCards = 10
    static var aspectRatioHeightUnits: CGFloat = 3.0 //1.0
    static var aspectRatioWidthUnits: CGFloat = 4.0 // 1.0
}

class CardSizeCalculator {
    public var collectionViewSections: CollectionViewSections
    
    private func respectAspectRatio(maxSize: CGSize) -> CGSize {
        var aspectRatioWidthToHeight = CardSizeConstants.aspectRatioWidthUnits / CardSizeConstants.aspectRatioHeightUnits
        var result = maxSize
        
        // For future implementation%
        // there are 3 possible cases of ethalon aspect ratio: H>W, H<W, H=W
        // The same way there are 3 cases of maxSize (H>W, H<W, H=W)
        // You have to check combinations of all cases which is total 3 * 3 = 9 possible cases
        
        /*
        switch result.longSide() {
        case .height:
            result.width = result.width / aspectRatioWidthToHeight
        case .width:
            result.height = result.height / aspectRatioWidthToHeight
        }
        
        
        let biggerSideSize = max(result.height , result.width)
        let smallerSideSize = min(result.height , result.width)

        var currentAspectRatio =
        */
        return result;
    }
    
    public func getCardSize(collectionViewFrameSize: CGSize, numberOfPairs: Int) -> CGSize {
        let collectionViewShortSideSize = collectionViewFrameSize.shortSideSize()
        let collectionViewLongSideSize = collectionViewFrameSize.longSideSize()

        var cardShortSideSize = CGFloat(1)
        var cardLongSideSize = CGFloat(1)
        
        let rowsCollomnsNumber = Difficulty(numberOfPairs).getRowsCollomnsNumber()
        
        // Calculate the maximal possible card size that will fit (without aspect ratio and spacings between cards)
        cardShortSideSize = collectionViewShortSideSize / CGFloat(rowsCollomnsNumber.shortSide)
        cardLongSideSize = collectionViewLongSideSize / CGFloat(rowsCollomnsNumber.longSide)
        
        // Take into account minimal spacings (gaps) between cards
        cardShortSideSize = cardShortSideSize - CGFloat(rowsCollomnsNumber.shortSide+1 * CardSizeConstants.minSpacingBetweenCards)
        cardLongSideSize = cardLongSideSize - CGFloat(rowsCollomnsNumber.longSide+1 * CardSizeConstants.minSpacingBetweenCards)
        
        // Apply the calculated short and long sides to height or width depending on what side is longer
        var calculatedCardSize: CGSize
        switch collectionViewFrameSize.longSide() {
        case .height:
            calculatedCardSize = CGSize(width: cardShortSideSize, height: cardLongSideSize)
        case .width:
            calculatedCardSize = CGSize(width: cardLongSideSize, height: cardShortSideSize)
        }
        
        // Respect aspect ratio
        calculatedCardSize = respectAspectRatio(maxSize: calculatedCardSize)
        
        return calculatedCardSize
    }
    
    init() {
        collectionViewSections = CollectionViewSections()
    }
    
}
