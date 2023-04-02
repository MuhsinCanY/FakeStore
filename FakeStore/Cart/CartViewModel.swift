//
//  CartViewModel.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 3.04.2023.
//

import Foundation
import RealmSwift

class CartViewModel{
    
    lazy var realm = try! Realm()
    
    var data: Observable<[ProductCart]> = Observable()
    

    func recievedData(){
        
        data.value = Array(self.realm.objects(ProductCart.self))
    }
    
}
