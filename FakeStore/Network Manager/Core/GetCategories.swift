//
//  GetCategories.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 5.03.2023.
//

import Foundation
import Alamofire

class GetCategories{
    
    static let shared = GetCategories()
    
    private init() { }
    
    func getCategories(complete: @escaping ( ([String]) -> () ) ){
        NetworkManager.shared.request(
            type: [String].self,
            url: "\(NetworkHelper.shared.baseUrl)\(Endpoint.products.rawValue)/\(Endpoint.categories.rawValue)",
            method: .get) { result in
                switch result{                    
                case .success(let data):
                    var categories = data
                    categories.insert("All", at: 0)
                    complete(categories)
                case .failure(_):
                    complete(["Error"])
                }
            }
    }
    
    func getCategoriesWithURLSession(completion: @escaping ([String]) -> Void){
        let url = URL(string: "https://fakestoreapi.com/products/categories")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                let json = try? JSONDecoder().decode([String].self, from: data)
                if let json = json{
                    var categories = json
                    categories.insert("All", at: 0)
                    completion(categories)
                }
            }
        }.resume()
    }
    
}
