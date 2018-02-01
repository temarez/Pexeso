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
        // TODO: we have to set here numberOfSections = numberOfPairs * 2 and numberOfItemsInSection = 1
        // we will have multiple sections with single item in each and it will allow us to use UIEdgeInsets in order to set gaps between sections
    }
}

struct GameRulesConstants {
    static var allowedTimeForPairToFlip = 5
}

class GameVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GameEventsDelegate {
    @IBOutlet weak var collectionView: CardCollectionView?
    @IBOutlet weak var flipsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabelWithTimer!

    var numOfPairsPickerDelegate: NumOfPairsPickerDelegate?
    var numberOfPairs = 2
    var collectionViewSections = CollectionViewSections()
    var cardSizeCalculator = CardSizeCalculator()
    
    var pexesoEngine: PexesoEngine?
    
    var flipCount = 0 {
        didSet {
            flipsLabel.text = "Flips: \(flipCount)"
        }
    }
    
    var theme = Theme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.dataSource = self
        collectionView?.delegate = self

        if let delegate = numOfPairsPickerDelegate {
            numberOfPairs = delegate.getPickerViewSelectedNumOfPairs()
        }
        print("Selected num of pairs \(numberOfPairs)")
        collectionViewSections = CollectionViewSections(numberOfPairs)
        cardSizeCalculator.collectionViewSections = collectionViewSections
        
        print("numberOfSections is \(collectionViewSections.numberOfSections) and numberOfItemsInSection is \(collectionViewSections.numberOfItemsInSection)")
        startNewGame()
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
        
        cell.cardButton.setImage(theme.imageBack(), for: .normal)
        cell.cardButton.addTarget(self, action: #selector(cardBtnClicked), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cardSizeCalculator.getCardSize(collectionViewFrameSize: collectionView.frame.size, numberOfPairs: numberOfPairs)
    }
    
    /**/
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    /**/
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    // TODO: it is a better to process device rotation event here, not in viewDidLayoutSubviews()
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let orient = UIApplication.shared.statusBarOrientation
        switch orient {
        case .portrait:
            print("Device is in portrait orientation")
        default:
            print("Device is in non-portrait orientation")
        }
    }
    
    
    // MARK: new attempt to implement logics
    
    func startNewGame() {
        pexesoEngine = PexesoEngine(numberOfPairsOfCards: numberOfPairs)
        pexesoEngine?.gameEventsDelegate = self
        flipCount = 0
        timeLabel.myTimerStart(seconds: TimeInterval(numberOfPairs * GameRulesConstants.allowedTimeForPairToFlip))
        updateViewFromModel()
        // make buttons visible and in default state again!!!
    }
    
    // func eventTimerEnd() TODO: implement
    
    func getButtonByCardIndex(_ cardIndex: Int) -> UIButton? {
        let indexPath = collectionViewSections.getCellIndexPath(index: cardIndex)
        if let cell = collectionView?.cellForItem(at: indexPath) as? CardCollectionViewCell {
            return cell.cardButton
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
            if let card = pexesoEngine?.cards[cardNumber] {
                print("Card clicked in cell " + String(unwrapIndexPath.section) + ", " + String(unwrapIndexPath.row) + " => card index = " + String(collectionViewSections.getCellIndex(indexPath: unwrapIndexPath)) + " card ID = \(card.identifier)")
                
                sender.cardOpenAnimation() // TODO: is this necessary?
                pexesoEngine?.chooseCard(at: cardNumber)
                pexesoEngine?.check()
                //updateViewFromModel()
            }
        }
    }
    
    // TODO: is this necessary
    func updateViewFromModel() {
        guard let pexesoEngine = pexesoEngine else {
            return
        }
        for (cardIndex, card) in pexesoEngine.cards.enumerated() {
            if let button = getButtonByCardIndex(cardIndex) {
                if card.isMatched {
                    //button.setTitle("!", for: .normal)
                } else {
                    button.cardsMatchAnimationUndo()
                    if card.isFaceUp {
                        button.setImage(theme.image(for: card), for: .normal)
                    } else {
                        button.setImage(theme.imageBack(), for: .normal)
                    }
                }
            }
        }
    }
    
    func gameEventCardOpened(cardIndex: Int) {
        print("Event: Card Opened - \(cardIndex)")
        if let button = getButtonByCardIndex(cardIndex), let card = pexesoEngine?.cards[cardIndex] {
            button.cardOpenAnimation()
            button.setImage(theme.image(for: card), for: .normal)
            //button.setTitle(String("[\(cardIndex)] \(card.identifier)"), for: .normal)
        }
    }
    
    func gameEventCardClosed(cardIndex: Int) {
        print("Event: Card Closed - \(cardIndex)")
        if let button = getButtonByCardIndex(cardIndex) {
            button.cardCloseAnimation()
            button.setImage(theme.imageBack(), for: .normal)
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
                button1.setImage(self.theme.imageBack(), for: .normal)
                button2.setImage(self.theme.imageBack(), for: .normal)
            })
        }
    }
    
    func gameEventVictory() {
        print("Event: Victory")
        timeLabel.myTimerStop()
        let scoreForFlipsPcnt = Int(numberOfPairs * 2 * 100 / flipCount)
        let bestPossibleTime = TimeInterval(numberOfPairs * GameRulesConstants.allowedTimeForPairToFlip)
        var scoreForTime = TimeInterval(100)
        if(timeLabel.counterValue > bestPossibleTime) {
            scoreForTime = timeLabel.counterValue - bestPossibleTime
        }
        let scoreForTimePcnt = Int(scoreForTime)
        let score = Int((scoreForFlipsPcnt + scoreForTimePcnt) / 2)
        
        // TODO: add some delay here and maybe even animation or user
        let alertController = UIAlertController(title: "Victory", message: "Congratulations, you've got \(score) points. Do you wish to replay?", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter your name"
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.performSegue(withIdentifier: "GameVC2HighScoresVC", sender: nil)
        }
        alertController.addAction(actionCancel)
        
        let actionOK = UIAlertAction(title: "OK", style: .default, handler: {
            alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            if let name = firstTextField.text {
                UserService.instance.addUser(name: name, cardsPairsNumber: self.numberOfPairs, score: score)
            }
            self.startNewGame()
        })
        alertController.addAction(actionOK)
        
        present(alertController, animated: true)
    }

    
}
