//
//  CALayer+Ext.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 4.04.2023.
//

import UIKit

extension CALayer {
    
    func border(cornerRadius: CGFloat, borderColor: CGColor = CGColor(gray: 0, alpha: 0.5), borderWidth: CGFloat = 1.0){
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
    }
    
    func round() {
        self.cornerRadius = self.bounds.width / 2
        self.masksToBounds = true
    }
}
