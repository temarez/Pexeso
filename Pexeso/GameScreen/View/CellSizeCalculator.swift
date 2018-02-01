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

class CellSizeCalculator {
    
    public let cellSizeMax = CGSize(width: 1024, height: 1024)
    public let spacingBetweenCards = 10
    public var collectionViewSize: CGSize
    public var collectionViewSections: CollectionViewSections
    
    public func cellSize(collectionViewFrameSize: CGSize, numberOfCells: Int) -> CGSize {
        
        let shortSideSize = collectionViewFrameSize.shortSideSize()
        //print("ShortSideSize: \(shortSideSize)")
        var calculatedCardWidth = CGFloat(1)
        var calculatedCardHeight = CGFloat(1)
        
        if numberOfCells <= 12 {
            calculatedCardWidth = shortSideSize/3-16
            calculatedCardHeight = shortSideSize/3-16
        }
        else if numberOfCells <= 24 {
            calculatedCardWidth = shortSideSize/4-14
            calculatedCardHeight = shortSideSize/4-14
        }
        else {
            calculatedCardWidth = shortSideSize/5-12
            calculatedCardHeight = shortSideSize/5-12
        }

        var calculatedCardSize = CGSize(width: calculatedCardWidth, height: calculatedCardHeight)
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
        collectionViewSize = CGSize(width: 1, height: 1)
        collectionViewSections = CollectionViewSections()
    }
    
}
