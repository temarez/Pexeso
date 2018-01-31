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
        numberOfSections = 1 // TODO: implement more sopisticated way with multiple numberOfSections
        numberOfItemsInSection = numberOfPairs * 2
    }
}

class GameVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GameEventsDelegate {
    @IBOutlet weak var collectionView: CardCollectionView?
    @IBOutlet weak var flipsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabelWithTimer!

    var numOfPairsPickerDelegate: NumOfPairsPickerDelegate?
    var numberOfPairs = 2
    var collectionViewSections = CollectionViewSections()
    var cardsSizeCalculator = CardsSizeCalculator()
    
    var pexesoEngine: PexesoEngine?
    
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

        pexesoEngine = PexesoEngine(numberOfPairsOfCards: numberOfPairs)
        pexesoEngine?.gameEventsDelegate = self

        timeLabel.myTimerStart(seconds: TimeInterval(numberOfPairs*4))
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
        cell.cardButton.backgroundColor = .gray
        cell.cardButton.addTarget(self, action: #selector(cardBtnClicked), for: UIControlEvents.touchUpInside)
        /*
        print("INDEX: " + String(currentCellNumber) + " [" + String(indexPath.section) + "," + String(indexPath.row) + "]")

        // Configure the cell
        let imageName = "i0" + String(currentCellNumber);
        let image = UIImage(named: imageName)
        cell.cardButton.setTitle(String(currentCellNumber), for: .normal)
        //cell.cardButton.setTitle(String(pexesoEngine.cards[indexPath.item].identifier), for: .normal)
        //cell.cardButton.setImage(image, for: UIControlState.normal)
        //cell.cardButton.setImage(#imageLiteral(resourceName: "i14"), for: UIControlState.normal)
        
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.red.cgColor
        
        */
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
    
    // MARK: new attempt to implement logics
    
    func getButtonByCardIndex(_ cardIndex: Int) -> UIButton? {
        let indexPath = collectionViewSections.getCellIndexPath(index: cardIndex)
        if let cell = collectionView?.cellForItem(at: indexPath) as? CardCollectionViewCell {
            return cell.cardButton
        }
        return nil
        /*
        for cardBtn in cardButtons {
            if cardBtn.tag == cardIndex {
                return cardBtn
            }
        }
        return nil
         */
    }
    
    @objc func cardBtnClicked(sender: UIButton) {
        flipCount += 1
        
        var indexPath: IndexPath? = nil
        if let cell = getSuperviewCollectionViewCell(view: sender) {
            indexPath = collectionView?.indexPath(for: cell)
        }
        
        if let unwrapIndexPath = indexPath {
            let cardNumber = collectionViewSections.getCellIndex(indexPath: unwrapIndexPath)
            if let card = pexesoEngine?.cards[cardNumber] {
                print("Card button clicked in cell " + String(unwrapIndexPath.section) + ", " + String(unwrapIndexPath.row) + " => index = " + String(collectionViewSections.getCellIndex(indexPath: unwrapIndexPath)) + " card ID = \(card.identifier)")
                
                sender.cardOpenAnimation() // TODO: is this necessary?
                pexesoEngine?.chooseCard(at: cardNumber)
                pexesoEngine?.check()
                //updateViewFromModel()
            }
        }
    }
    
    func updateViewFromModel() {
        guard let pexesoEngine = pexesoEngine else {
            return
        }
        for (cardIndex, card) in pexesoEngine.cards.enumerated() {
            //print("\(cardIndex) CARD ID \(card.identifier)")
            if let button = getButtonByCardIndex(cardIndex) {
                if card.isMatched {
                    button.setTitle("!", for: .normal)
                } else {
                    if card.isFaceUp {
                        button.setTitle(String("[\(cardIndex)] \(card.identifier)"), for: .normal)
                    } else {
                        button.setTitle("?", for: .normal)
                    }
                }
            }
        }
    }
    
    func gameEventCardOpened(cardIndex: Int) {
        print("Event: Card Opened - \(cardIndex)")
        if let button = getButtonByCardIndex(cardIndex), let card = pexesoEngine?.cards[cardIndex] {
            button.cardOpenAnimation()
            button.setTitle(String("[\(cardIndex)] \(card.identifier)"), for: .normal)
        }
    }
    
    func gameEventCardClosed(cardIndex: Int) {
        print("Event: Card Closed - \(cardIndex)")
        if let button = getButtonByCardIndex(cardIndex) {
            button.cardCloseAnimation()
            button.setTitle(String("?"), for: .normal)
        }
    }
    
    func gameEventCardsMatched(card1Index: Int, card2Index: Int) {
        print("Event: Cards Matched - \(card1Index) \(card2Index)")
        if let button1 = getButtonByCardIndex(card1Index) {
            button1.cardsMatchAnimation()
        }
        if let button2 = getButtonByCardIndex(card2Index) {
            button2.cardsMatchAnimation()
        }
    }
    
    func gameEventCardsMismatched(card1Index: Int, card2Index: Int) {
        print("Event: Cards Mismatched - \(card1Index) \(card2Index)")
        if let button1 = getButtonByCardIndex(card1Index), let button2 = getButtonByCardIndex(card2Index) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: { // use timer to pause so user can see selections - 0.7 sec
                button1.cardCloseAnimation()
                button2.cardCloseAnimation()
                button1.setTitle(String("?"), for: .normal)
                button2.setTitle(String("?"), for: .normal)
            })
        }
    }
    
    func gameEventVictory() {
        print("Event: Victory")
        let alertController = UIAlertController(title: "Victory", message: "You won. Do you wish to replay", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // TODO: Go to high scores screen
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // TODO: Start a new game
        }
        alertController.addAction(OKAction)
        
        present(alertController, animated: true)
    }

    
}
