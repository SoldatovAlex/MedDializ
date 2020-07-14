//
//  NetworkService.swift
//  MedDializ
//

import Alamofire
import Foundation

enum URLs {
    static let base = "http://127.0.0.1:5002/"
    static let initObj = URL(string: base + "init")!
    static let getWeight = URL(string: base + "get_weight")!
    static let start = URL(string: base + "start_dializ")!
    static let end = URL(string: base + "end_dializ")!
}

final class NetworkServiceImpl {
    
    private let sessionManager: SessionManager
    
    required init(sessionManager: SessionManager = SessionManager.default) {
        self.sessionManager = sessionManager
    }
    
    func request(url: URL, completion: @escaping (String) -> Void)  {
        sessionManager.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                let str = String(data: data, encoding: .utf8) ?? "Error"
                completion(str)
            case .failure(_):
                completion("Error occured")
            }
        }
    }
}


