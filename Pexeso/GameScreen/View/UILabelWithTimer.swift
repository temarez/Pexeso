//
//  UILabelWithTimer.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 25.01.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import UIKit

class UILabelWithTimer: UILabel {
    
    public var counterValue: TimeInterval = 0
    private lazy var timer = Timer()
    
    deinit {
        timer.invalidate()
    }
    
    func myTimerStart(seconds: TimeInterval) {
        counterValue = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(myTimerCounter), userInfo: nil, repeats: true)
    }
    
    @objc func myTimerCounter() {
        counterValue += 1
        self.text = "Time: " + String(Int(counterValue))
        if (counterValue == 0) {
            myTimerStop()
        }
    }
    
    func myTimerStop() {
        timer.invalidate()
    }

}
