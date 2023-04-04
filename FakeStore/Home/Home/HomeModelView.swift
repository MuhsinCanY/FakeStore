//
//  HomeModelView.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 3.04.2023.
//

import Foundation
import RealmSwift

class HomeModelView{
    
    lazy var realm = try! Realm()
    
    var products: Observable<Product> = Observable()
    var cartProductsCount: Observable<Int> = Observable()
    var categories: Observable<[String]> = Observable()
    var shouldAnimateCollectionView: Observable<Bool> = Observable()
    
    func fetchData(){
        shouldAnimateCollectionView.value = true
        GetProduct.shared.getProduct { product in
            if let product = product{
                self.products.value = product
                self.shouldAnimateCollectionView.value = false
            }
        }
    }
    
    func fetchCartProductCount(){
        cartProductsCount.value = Array(self.realm.objects(ProductCart.self)).count
    }
    
    func fetchCategories(){
        GetCategories.shared.getCategories { categories in
            self.categories.value = categories
        }
    }
    
    func fetchSearchProducts(with searchText: String){
        if searchText == ""{
            fetchData()
        }else{
            if searchText.count >= 2{
                shouldAnimateCollectionView.value = true
                GetProduct.shared.getProduct { product in
                    self.products.value?.removeAll()
                    product?.forEach({ element in
                        if element.title.lowercased().contains(searchText.lowercased()){
                            self.products.value?.append(element)
                        }
                    })
                    self.shouldAnimateCollectionView.value = false
                }
            }
        }
    }
    
    func fetchProductsSelectedCategory(category: String){
        let categoryEncoded = category.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        if categoryEncoded == "All"{
            fetchData()
        }else{
            shouldAnimateCollectionView.value = true
            GetProduct.shared.getProduct(withCategory: categoryEncoded) { product in
                if let product = product{
                    self.products.value = product
                    self.shouldAnimateCollectionView.value = false
                }
            }
            
        }
    }
    
}
