//
//  Photo.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 21.03.2023.
//

import UIKit
import RealmSwift

class Photo: Object{
    @objc dynamic var imageData = UIImage(named: "user")?.jpegData(compressionQuality: 0.5)
    
    convenience init(imageData: Data) {
        self.init()
        self.imageData = imageData
    }
}
