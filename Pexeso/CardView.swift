//
//  CardView.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 20.01.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import UIKit

struct Constants {
    static var flipCardAnimationDuration: TimeInterval = 0.6
    static var matchCardAnimationDuration: TimeInterval = 0.6
    static var matchCardAnimationScaleUp: CGFloat = 3.0
    static var matchCardAnimationScaleDown: CGFloat = 0.1
    static var behaviorResistance: CGFloat = 0
    static var behaviorElasticity: CGFloat = 1.0
    static var behaviorPushMagnitudeMinimum: CGFloat = 0.5
    static var behaviorPushMagnitudeRandomFactor: CGFloat = 1.0
    static var cardsPerMainViewWidth: CGFloat = 5
}

class CardView: UIView {

    // TODO: will propably implement the card-related view staff here later (instead of using buttons etc)
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func cardsMatchAnimation(view: UIView, completion: (() -> Swift.Void)? = nil)  {
        let animator = UIViewPropertyAnimator(
            duration: Constants.matchCardAnimationDuration,
            curve: .linear ,
            animations: {
                view.center = view.superview!.center
                view.transform = CGAffineTransform.identity.scaledBy(x: Constants.matchCardAnimationScaleUp,
                                                                     y: Constants.matchCardAnimationScaleUp)
        })
        animator.addCompletion({ position in
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: Constants.matchCardAnimationDuration,
                delay: 0, options: [],
                animations: {
                    view.transform = CGAffineTransform.identity.scaledBy(x: Constants.matchCardAnimationScaleDown,
                                                                         y: Constants.matchCardAnimationScaleDown)
                    view.alpha = 0
            },
                completion: { position in
                    view.isHidden = true
                    view.alpha = 1
                    view.transform = .identity
            }
            )
        })
        animator.addCompletion({ position in
            completion?()
        })
        animator.startAnimation()
    }

}
