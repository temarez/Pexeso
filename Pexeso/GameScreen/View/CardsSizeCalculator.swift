//
//  CardsSizeCalculator.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 29.01.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import UIKit

/// How to fit cards in the collection view
enum FitCardInCollection {
    case sectionByWidth // height
    case sectionByHeight // width
}

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
    
}

class CardsSizeCalculator {
    
    public let cardSizeMax = CGSize(width: 1024, height: 1024)
    public var collectionViewSize: CGSize
    public var collectionViewSections: CollectionViewSections
    
    public var cardSize: CGSize {
        print("CARD_SIZE")
        print("CollectionViewSize: \(collectionViewSize) larger \(collectionViewSize.largerSide()) smaller \(collectionViewSize.smallerSide())")
        print("CollectionViewSize: \(collectionViewSize) larger \(collectionViewSize.largerSideSize()) smaller \(collectionViewSize.smallerSideSize())")
        print()
        if(collectionViewSize.height>collectionViewSize.width) {
            //collectionViewSections.numberOfSections !!!!!!
        }
        print("\(collectionViewSections.numberOfSections) x \(collectionViewSections.numberOfItemsInSection)")
        return CGSize(width: 186, height: 186) // TODO: get rid of hard-coded values, calculate with collectionViewSize
    }
    
    init() {
        collectionViewSize = CGSize(width: 1, height: 1)
        collectionViewSections = CollectionViewSections()
    }
    
}
