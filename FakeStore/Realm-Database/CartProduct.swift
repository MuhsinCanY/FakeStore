//
//  DatabaseModel.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 14.03.2023.
//

import Foundation
import RealmSwift

class ProductCart: Object{
    
    @objc dynamic var id = 0
    @objc dynamic var productQuantity = 0
    @objc dynamic var title = ""
    @objc dynamic var price: Double = 0
    @objc dynamic var image = ""
    @objc dynamic var rate: Double = 0
    @objc dynamic var count = 0
    @objc dynamic var check = true
    
    convenience init(id: Int, productQuantity: Int , title: String, price: Double, image: String, rate: Double, count: Int, check: Bool) {
        self.init()
        self.id = id
        self.productQuantity = productQuantity
        self.title = title
        self.price = price
        self.image = image
        self.rate = rate
        self.count = count
        self.check = check
    }
}
