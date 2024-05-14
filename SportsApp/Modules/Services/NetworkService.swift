//
//  File.swift
//  SportsApp
//
//  Created by Israa Assem on 13/05/2024.
//

import Foundation
import Alamofire
protocol NetworkServiceProtocol{
    func fetchData<T:Decodable>(completion:@escaping([T]?,Error?)->Void,url:URL)
}
class NetworkService:NetworkServiceProtocol{
    func fetchData<T:Decodable>(completion:@escaping([T]?,Error?)->Void,url:URL){
              
        AF.request(url).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                if let data=data as? [T]{
                    completion(data,nil)
                    print(data)
                }else{
                    completion(nil,NSError(domain: "Parsing error", code: 0, userInfo: [NSLocalizedDescriptionKey:"Failed to parse response"]))
                }
            case .failure(let error):
                completion(nil,error)
            }
        }
        
    }
}
