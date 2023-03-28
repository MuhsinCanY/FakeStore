//
//  CustomImageView.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 13.03.2023.
//

import UIKit

class CustomImageView: UIImageView{
    
    func productImageView()->UIImageView{
        
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.white
        imageView.contentMode = .scaleAspectFit
        return imageView
        
    }
    
}
