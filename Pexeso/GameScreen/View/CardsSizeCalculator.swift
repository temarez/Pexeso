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
    
    func largerSide() -> RectSide {
        if(self.height >= self.width) {
            return RectSide.height
        }
        else {
            return RectSide.width
        }
    }
    
    func smallerSide() -> RectSide {
        var smallerSide = RectSide.width
        let largerSide = self.largerSide()
        switch largerSide {
        case .height:
            smallerSide = RectSide.width
        case .width:
            smallerSide = RectSide.height
        }
        return smallerSide
    }
    
    private func sideSize(side: RectSide) -> CGFloat {
        switch side {
        case .height:
            return self.height
        case .width:
            return self.width
        }
    }
    
    func largerSideSize() -> CGFloat {
        return sideSize(side: largerSide())
    }
    
    func smallerSideSize() -> CGFloat {
        return sideSize(side: smallerSide())
    }
    
    /*
    /// This should scale the size down if it is more then maxSize or otherwise leave it unchanged
    func fitToMaxSize(maxSize: CGSize) {
        var ratioHeight: CGFloat = self.height / maxSize.height
        var ratioWidth: CGFloat = self.width / maxSize.width
    }
 */
    
}

class CardsSizeCalculator {
    
    public let cardSizeMax = CGSize(width: 1024, height: 1024)
    public let spacingBetweenCards = 10
    public var collectionViewSize: CGSize
    public var collectionViewSections: CollectionViewSections
    
    private func calcCardSingleSideSize(sideSize: CGFloat, cardsNum: Int, spacing: Int) -> CGFloat {
        if cardsNum < 1 {
            return sideSize
        }
        return sideSize / CGFloat((cardsNum-1)*spacing)
    }
    
    public var cardSize: CGSize {
        /*
        print("CARD_SIZE")
        print("CollectionViewSize: \(collectionViewSize) larger \(collectionViewSize.largerSide()) smaller \(collectionViewSize.smallerSide())")
        print("CollectionViewSize: \(collectionViewSize) larger \(collectionViewSize.largerSideSize()) smaller \(collectionViewSize.smallerSideSize())")
        */
        var calculatedCardSize = CGSize(width: 186, height: 186) // TODO: get rid of hard-coded values, calculate with collectionViewSize
        /*
        if(collectionViewSections.numberOfSections > collectionViewSections.numberOfItemsInSection) {
            calculatedCardSize.height = calcCardSingleSideSize(sideSize: collectionViewSize.largerSideSize(), cardsNum: collectionViewSections.numberOfSections, spacing: spacingBetweenCards)
         
            calculatedCardSize.width = collectionViewSize.smallerSideSize() / CGFloat(collectionViewSections.numberOfItemsInSection)
        }
        else {
        }*/
        
        //CGFloat larger collectionViewSize.largerSideSize()
        
        //print("SECTIONS: \(collectionViewSections.numberOfSections) x \(collectionViewSections.numberOfItemsInSection)")
        //print("CALC CARD SIZE: \(calculatedCardSize.width) x \(calculatedCardSize.height)")

        return calculatedCardSize
    }
    
    init() {
        collectionViewSize = CGSize(width: 1, height: 1)
        collectionViewSections = CollectionViewSections()
    }
    
}
