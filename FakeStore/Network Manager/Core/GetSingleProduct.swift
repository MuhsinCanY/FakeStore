//
//  GetSingleProduct.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 7.03.2023.
//

import Foundation

class GetSingleProduct{
    
    static let shared = GetSingleProduct()
    
    private init() { }
    
    func getSingleProduct(id: Int, complete: @escaping ( (ProductElement?) -> () ) ){
        
        NetworkManager.shared.request(
            type: ProductElement.self,
            url: "\(NetworkHelper.shared.baseUrl)\(Endpoint.products.rawValue)/\(id)",
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
