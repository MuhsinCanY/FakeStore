//
//  UIButton+Ext.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 14.03.2023.
//

import UIKit

extension UIButton{
    
    func setImageWithColor(name: String, color: UIColor){
            setImage(UIImage(named: name)?.withTintColor(color, renderingMode: .alwaysOriginal), for: .normal)
            setImage(UIImage(named: name)?.withTintColor(color, renderingMode: .alwaysOriginal), for: .highlighted)
    }
    
    func checkBoxFill(){
        setImage(UIImage(named: "checkBoxFill"), for: .normal)
    }
    
    func checkBoxEmpty(){
        setImage(UIImage(named: "checkBoxEmpty"), for: .normal)
    }
}
