//
//  Favorite.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 30.03.2023.
//

import Foundation
import RealmSwift

class Favorite2: Object{
    @objc dynamic var productId = -1
    
    convenience init(productId: Int) {
        self.init()
        self.productId = productId
    }
}
