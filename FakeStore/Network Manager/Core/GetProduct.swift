//
//  GetProduct.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 5.03.2023.
//

import Foundation

class GetProduct{
    
    static let shared = GetProduct()
    
    private init() { }
    
    func getProduct(complete: @escaping ( (Product?) -> () ) ){
        
        NetworkManager.shared.request(
            type: Product.self,
            url: "\(NetworkHelper.shared.baseUrl)\(Endpoint.products.rawValue)",
            method: .get) { response in
            
            switch response{
            case .success(let data):
                complete(data)
            case .failure(_):
                complete(nil)
            }
        }
    }
    
    func getProduct(withCategory category: String, complete: @escaping ( (Product?) -> () ) ){
        
        NetworkManager.shared.request(
            type: Product.self,
            url: "\(NetworkHelper.shared.baseUrl)\(Endpoint.products.rawValue)/category/\(category)",
            method: .get) { response in
            
            switch response{
            case .success(let data):
                complete(data)
            case .failure(_):
                complete(nil)
            }
        }
    }
}
