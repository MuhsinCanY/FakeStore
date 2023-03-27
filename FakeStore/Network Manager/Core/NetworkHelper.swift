//
//  NetworkHelper.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 5.03.2023.
//

import Foundation

class NetworkHelper{
    
    static let shared = NetworkHelper()
    
    let baseUrl = "https://fakestoreapi.com/"
    
}

enum Endpoint: String{
    case products = "products"
    case categories = "categories"
}
