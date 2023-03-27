//
//  UIView+Ext.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 11.03.2023.
//

import UIKit

extension UIView{
    
    public func addSubviews(_ views: UIView...){
        views.forEach(addSubview(_:))
    }
    
}
