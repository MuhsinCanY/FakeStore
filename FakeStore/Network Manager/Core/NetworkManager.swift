//
//  NetworkManager.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 5.03.2023.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    func request<T>(type: T.Type, url: String, method: HTTPMethod, completion: @escaping (Result<T, AFError>) -> ()) where T:Codable {
        
        AF.request(url, method: method).responseDecodable(of: T.self) { response in
            switch response.result{
                
            case .success(let data):
                completion(.success(data))
            case .failure(_):
                completion(.failure(.sessionTaskFailed(error: AFError.explicitlyCancelled)))
            }
        }
        
    }
    
    
}
