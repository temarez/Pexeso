//
//  CardView.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 20.01.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import UIKit

struct Constants {
    static var matchCardAnimationDuration: TimeInterval = 0.6
    static var matchCardAnimationScaleDown: CGFloat = 0.1
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
    
    func cardsMatchAnimation(view: UIView)  {
        let animator = UIViewPropertyAnimator(
            duration: Constants.matchCardAnimationDuration,
            curve: .linear ,
            animations: {
                view.center = view.superview!.center
                view.transform = CGAffineTransform.identity.scaledBy(x: Constants.matchCardAnimationScaleDown,
                                                                     y: Constants.matchCardAnimationScaleDown)
                view.alpha = 0
        })
        animator.startAnimation()
    }

}
