//
//  GameVC.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 17.01.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

// TODO: move the code from this class to CardCollectionView
class CollectionViewSections {
    var numberOfSections: Int
    var numberOfItemsInSection: Int
    
    func getCellIndex(indexPath: IndexPath) -> Int {
        return indexPath.section * numberOfItemsInSection + indexPath.row
    }
    
    // TODO: cover with unit tests for different numbers
    func getCellIndexPath(index: Int) -> IndexPath {
        let row = index % numberOfItemsInSection
        let section = index / numberOfItemsInSection
        return IndexPath(row: row, section: section)
    }
    
    init() {
        numberOfSections = 1
        numberOfItemsInSection = 1
    }
    
    init(_ numberOfPairs: Int) {
        numberOfSections = numberOfPairs
        numberOfItemsInSection = 2 // TODO: implement
    }
}

class GameVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: CardCollectionView?
    @IBOutlet weak var flipsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabelWithTimer!

    var numOfPairsPickerDelegate: NumOfPairsPickerDelegate?
    var numberOfPairs = 2
    var collectionViewSections = CollectionViewSections()
    var cardsSizeCalculator = CardsSizeCalculator()
    
    lazy var pexesoGame: Pexeso = Pexeso(numberOfPairsOfCards: numberOfPairs)
    
    var flipCount = 0 {
        didSet {
            flipsLabel.text = "Flips: \(flipCount)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        if let delegate = numOfPairsPickerDelegate {
            numberOfPairs = delegate.getPickerViewSelectedNumOfPairs()
        }
        print("Selected num of pairs \(numberOfPairs)")
        collectionViewSections = CollectionViewSections(numberOfPairs)
        cardsSizeCalculator.collectionViewSections = collectionViewSections
        
        print("numberOfSections is \(collectionViewSections.numberOfSections) and numberOfItemsInSection is \(collectionViewSections.numberOfItemsInSection)")

        timeLabel.myTimerStart(seconds: 20)
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionViewSections.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewSections.numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rawCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        guard let cell = rawCell as? CardCollectionViewCell else {
            fatalError("Oops: can not get the proper cell CardCollectionViewCell")
        }
        
        let currentCellNumber = collectionViewSections.getCellIndex(indexPath: indexPath)
        print("INDEX: " + String(currentCellNumber) + " [" + String(indexPath.section) + "," + String(indexPath.row) + "]")

        // Configure the cell
        let imageName = "i0" + String(currentCellNumber);
        let image = UIImage(named: imageName)
        cell.cardButton.setTitle(String(currentCellNumber), for: .normal)
        //cell.cardButton.setImage(image, for: UIControlState.normal)
        //cell.cardButton.setImage(#imageLiteral(resourceName: "i14"), for: UIControlState.normal)
        
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.red.cgColor
        
        cell.cardButton.addTarget(self, action: #selector(cardBtnClicked), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: calculate using UIScreen.main.bounds.size.height and UIScreen.main.bounds.size.width
        // TODO: see CardsSizeCalculator
        return cardsSizeCalculator.cardSize
    }
    
    func getSuperviewCollectionViewCell(view: UIView) -> UICollectionViewCell? {
        var currentView = view
        while currentView.superview != nil {
            if currentView is UICollectionViewCell {
                return currentView as? UICollectionViewCell
            }
            currentView = currentView.superview!
        }
        return nil
    }
    
    @objc func cardBtnClicked(sender: UIButton) {
        flipCount += 1
        
        var indexPath: IndexPath? = nil
        if let cell = getSuperviewCollectionViewCell(view: sender) {
            indexPath = collectionView?.indexPath(for: cell)
        }
        
        if let unwrapIndexPath = indexPath {
            let cardNumber = collectionViewSections.getCellIndex(indexPath: unwrapIndexPath)
            let card = pexesoGame.cards[cardNumber]
            
            print("Card button clicked in cell " + String(unwrapIndexPath.section) + ", " + String(unwrapIndexPath.row) + " => index = " + String(collectionViewSections.getCellIndex(indexPath: unwrapIndexPath)) + " card ID = \(card.identifier)")
            
            pexesoGame.chooseCard(at: cardNumber)
            if card.isFaceUp {
                //card.isFaceUp = false
                //let image = UIImage(named: "back")
                //sender.setImage(image, for: .normal)
                sender.cardCloseAnimation()
                //sender.cardsMatchAnimation()
            } else {
                //card.isFaceUp = true
                //let image = UIImage(named: "i01")
                //sender.setImage(image, for: .normal)
                sender.cardOpenAnimation()
            }
            updateViewFromModel()
        }
    }
    
    func updateViewFromModel() {
        let theme = Theme() // TODO:
        
        // let numberOfCards = numberOfPairs * 2
        // for index in 0..<numberOfCards
        for (cardIndex, card) in pexesoGame.cards.enumerated() {
            //print("\(cardIndex) CARD ID \(card.identifier)")
            let indexPath = collectionViewSections.getCellIndexPath(index: cardIndex)
            if let currentCell = collectionView?.cellForItem(at: indexPath) as? CardCollectionViewCell {
                if let button = currentCell.cardButton {
                    if card.isFaceUp {
                        button.setTitle(theme.image(for: card), for: UIControlState.normal)
                        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    } else {
                        button.setTitle("CLOSE", for: UIControlState.normal)
                        button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0.9960669949)
                    }
                }
            }
        }
    }
    
    // MARK: below part is an attempt to implement logics
    
    override func viewDidLayoutSubviews() {
        // TODO: see willRotateToInterfaceOrientation
        // TODO: see didRotateFromInterfaceOrientation
        super.viewDidLayoutSubviews()
        
        guard let unwrappedCollectionView = collectionView else {
            return
        }
        
        let collectionViewSize: CGSize = unwrappedCollectionView.frame.size
        cardsSizeCalculator.collectionViewSize = unwrappedCollectionView.frame.size
        let width = Int(collectionViewSize.width.rounded(.up))
        let height = Int(collectionViewSize.height.rounded(.up))
        
        //print("viewDidLayoutSubviews() " + String(width) + "x" + String(height))
    }
    
}
