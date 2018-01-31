//
//  CardView.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 20.01.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import UIKit

struct AnimationsConstants {
    static var matchCardAnimationDuration: TimeInterval = 0.6
    static var matchCardAnimationScaleDown: CGFloat = 0.1
    static var openCardAnimationDuration: TimeInterval = 0.3
    static var closeCardAnimationDuration: TimeInterval = 0.3
}

extension UIView {
    
    func cardsMatchAnimationUndo() {
        self.alpha = 1
        self.center = self.superview!.center
        self.transform = CGAffineTransform.identity.scaledBy(
            x: 1-AnimationsConstants.matchCardAnimationScaleDown,
            y: 1-AnimationsConstants.matchCardAnimationScaleDown)
    }
    
    func cardsMatchAnimation() {
        let animator = UIViewPropertyAnimator(
            duration: AnimationsConstants.matchCardAnimationDuration,
            curve: .linear ,
            animations: {
                self.center = self.superview!.center
                self.transform = CGAffineTransform.identity.scaledBy(
                    x: AnimationsConstants.matchCardAnimationScaleDown,
                    y: AnimationsConstants.matchCardAnimationScaleDown)
                self.alpha = 0
        })
        animator.startAnimation()
    }
    
    func cardOpenAnimation() {
        UIView.transition(
            with: self,
            duration: AnimationsConstants.openCardAnimationDuration,
            options: .transitionFlipFromRight,
            animations: nil,
            completion: nil)
    }
    
    func cardCloseAnimation () {
        UIView.transition(
            with: self,
            duration: AnimationsConstants.closeCardAnimationDuration,
            options: .transitionFlipFromLeft,
            animations: nil,
            completion: nil)
    }

}
