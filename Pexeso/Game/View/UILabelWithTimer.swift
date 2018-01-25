//
//  UILabelWithTimer.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 25.01.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import UIKit

class UILabelWithTimer: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private static let timeIntervalDefault: TimeInterval = 30.0
    private var timeInterval: TimeInterval = timeIntervalDefault
    private var timer = Timer()
    
    func myTimerStart(seconds: TimeInterval) {
        timeInterval = seconds
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(myTimerCounter), userInfo: nil, repeats: true)
    }
    
    @objc func myTimerCounter() {
        timeInterval -= 1
        self.text = "Time: \(timeInterval)"
        if (timeInterval == 0) {
            myTimerStop()
        }
    }
    
    func myTimerStop() {
        timer.invalidate()
        timeInterval = UILabelWithTimer.timeIntervalDefault
    }

}
