//
//  RoundedView.swift
//  Pexeso
//
//  Created by Artem Rieznikov on 01.02.18.
//  Copyright © 2018 SoftServe Academy. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    func setupUI() {
        self.clipsToBounds = true
        self.backgroundColor = .lightGray
        updateUI()
    }
    
    func updateUI() {
        //print("radius \(cornerRadius)")
        self.layer.cornerRadius = cornerRadius
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
}
