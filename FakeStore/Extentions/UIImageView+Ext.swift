//
//  UIImageView+Ext.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 7.03.2023.
//

import UIKit

extension UIImageView {
    
    func downloadSetImage(url: String) {
        guard let url = URL(string: url) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }
}
