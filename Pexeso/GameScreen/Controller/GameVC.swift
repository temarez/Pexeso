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

    var numOfPairsPickerDelegate: NumOfPairsPickerDelegate?
    var numberOfPairs = 2
    var collectionViewSections = CollectionViewSections()
    var cardsSizeCalculator = CardsSizeCalculator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        if let delegate = numOfPairsPickerDelegate {
            numberOfPairs = delegate.getPickerViewSelectedNumOfPairs()
        }
        print("Selected num of pairs \(numberOfPairs)")
        collectionViewSections = CollectionViewSections(numberOfPairs)
        cardsSizeCalculator.collectionViewSections = collectionViewSections
        
        print("numberOfSections is \(collectionViewSections.numberOfSections) and numberOfItemsInSection is \(collectionViewSections.numberOfItemsInSection)")

        timeLabel.myTimerStart(seconds: 20)
        // TODO: check below
        //(collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = cellSize
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
        var indexPath: IndexPath? = nil
        if let cell = getSuperviewCollectionViewCell(view: sender) {
            indexPath = collectionView?.indexPath(for: cell)
        }
        
        if let unwrapIndexPath = indexPath {
            print("Card button clicked in cell " + String(unwrapIndexPath.section) + ", " + String(unwrapIndexPath.row) + " => " + String(collectionViewSections.getCellIndex(indexPath: unwrapIndexPath)))
            
            let cardNumber = collectionViewSections.getCellIndex(indexPath: unwrapIndexPath) //cardButtons.index(of: sender) {
            pexesoGame.chooseCard(at: cardNumber)
            updateViewFromModelTodo()
        }
        flipCount += 1
    }
    
    func updateViewFromModelTodo() {
        /*
        let numberOfCards = numberOfPairs * 2
        // Go through all cells in collectionView
        for index in 0..<numberOfCards {
            print("Going through card number \(index) of \(numberOfCards)")
            let indexPath = collectionViewSections.getCellIndexPath(index: index)
            if let currentCell = collectionView?.cellForItem(at: indexPath) as? CardCollectionViewCell {
                currentCell.cardButton.setImage(nil, for: .normal)
                currentCell.cardButton.setTitle(String(index), for: .normal)
                currentCell.cardButton.backgroundColor = .brown
            }
        }
        */
        let theme = Theme() // TODO:
        
        // for index in 0..<numberOfCards
        for (cardIndex, card) in pexesoGame.cards.enumerated() {
            print("\(cardIndex) CARD ID \(card.identifier)")
            let indexPath = collectionViewSections.getCellIndexPath(index: cardIndex)
            if let currentCell = collectionView?.cellForItem(at: indexPath) as? CardCollectionViewCell {
                if let button = currentCell.cardButton {
                    if card.isFaceUp {
                        button.setTitle(theme.image(for: card), for: UIControlState.normal)
                        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    } else {
                        button.setTitle("", for: UIControlState.normal)
                        button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0.9960669949)
                    }
                }
            }
        }
        
        /*
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0.9960669949)
            }
        }
        */
    }
    
    // MARK: below part is an attempt to implement logics
    
    @IBOutlet weak var flipsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabelWithTimer!
    
    lazy var pexesoGame: Pexeso = Pexeso(numberOfPairsOfCards: numberOfPairs)
    
    var flipCount = 0 {
        didSet {
            flipsLabel.text = "Flips: \(flipCount)"
        }
    }
    
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
