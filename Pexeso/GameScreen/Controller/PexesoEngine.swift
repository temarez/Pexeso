//
//  PexesoEngine.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 30.01.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import Foundation

protocol GameEventsDelegate {
    func gameEventCardOpened(cardIndex: Int)
    func gameEventCardClosed(cardIndex: Int)
    func gameEventCardsMatched(card1Index: Int, card2Index: Int)
    func gameEventCardsMismatched(card1Index: Int, card2Index: Int)
    func gameEventVictory()
}

class PexesoEngine {
    /* Global Variables */
    var picks = 0 // counts how may picks have been made in each turn
    var firstChoiceCardIndex: Int? // stores index of first card selected
    var secondChoiceCardIndex: Int? // stores index of second card selected
    var matches = 0 // counts matches made
    var cards = [Card]() // array to store card images
    var numberOfPairsOfCards: Int
    var gameEventsDelegate: GameEventsDelegate?
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "PexesoEngine.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")

        self.numberOfPairsOfCards = numberOfPairsOfCards
        
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card] // Same as twice calling cards.append(card)
            // Please note that above code will work in other way with class -
            // it will add two references to the same card (since class is the refrence type)
        }
        cards.shuffle()
    }
    
    /* Responds to click on a table cell indicating card selected */
    func chooseCard(at cardIndex: Int) {
        // TODO: here I will pobably have to check if the card is already isFaceUp and send gameEventCardClosed()
        if (picks == 2) { //if 2 picks made, do nothing - stops player choosing 3 cards
            return;
        }
        if (picks == 0) { // if first pick, identify card selected
            firstChoiceCardIndex = cardIndex // load the index of the card that was clicked into first choice
            cards[cardIndex].isFaceUp = true
            gameEventsDelegate?.gameEventCardOpened(cardIndex: cardIndex)
            picks = 1 // one pick made
        } else {
            if let firstChoiceCardIndexUnwrap = firstChoiceCardIndex, firstChoiceCardIndexUnwrap == cardIndex {
                cards[cardIndex].isFaceUp = false
                firstChoiceCardIndex = nil
                secondChoiceCardIndex = nil
                picks = 0;
                gameEventsDelegate?.gameEventCardClosed(cardIndex: cardIndex)
                // User selected the same card which was already selected
            } else {
                // User selected 2nd card which differs from the 1st one selected
                picks = 2; // second pick, identify card selected
                secondChoiceCardIndex = cardIndex; // load the index of the card that was clicked into second choice
                cards[cardIndex].isFaceUp = true
                gameEventsDelegate?.gameEventCardOpened(cardIndex: cardIndex)
            }
        }
    }
    
    /* Check to see it a match is made */
    func check() {
        guard let secondChoiceCardIndexUnwrap = secondChoiceCardIndex, let firstChoiceCardIndexUnwrap = firstChoiceCardIndex else {
            return
        }

        if (cards[secondChoiceCardIndexUnwrap] == cards[firstChoiceCardIndexUnwrap]) { // if a match is selected
            cards[firstChoiceCardIndexUnwrap].isMatched = true
            cards[secondChoiceCardIndexUnwrap].isMatched = true
            firstChoiceCardIndex = nil
            secondChoiceCardIndex = nil
            
            matches += 1; // add 1 to matches
            picks = 0
            gameEventsDelegate?.gameEventCardsMatched(card1Index: firstChoiceCardIndexUnwrap, card2Index: secondChoiceCardIndexUnwrap)
            if (matches == numberOfPairsOfCards) { //if matches made = maximum possible matches, display message
                gameEventsDelegate?.gameEventVictory()
            }
        } else { //if no match made, turn cards back over and set picks to 0
            cards[firstChoiceCardIndexUnwrap].isFaceUp = false
            cards[secondChoiceCardIndexUnwrap].isFaceUp = false
            firstChoiceCardIndex = nil
            secondChoiceCardIndex = nil
            gameEventsDelegate?.gameEventCardsMismatched(card1Index: firstChoiceCardIndexUnwrap, card2Index: secondChoiceCardIndexUnwrap)
            picks = 0;
        }
    }
    
}

// Extension to the `MutableCollection` protocol (to which Array struct conforms) - add a shuffle() method
extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

