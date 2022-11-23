//
//  BithumbServiceAPI.swift
//  MoyaPractice
//
//  Created by 김규철 on 2022/11/23.
//

import Foundation
import Moya

public class BithumbServiceAPI {
    
    static let shared = BithumbServiceAPI()
    
    var bithumbProvider = MoyaProvider<BithumbAPIService>()
    
    var orderCurrency = "BTC"
    var paymentCurrency = "KRW"
    
    public init() { }
    
    func getBithumbs(completion: @escaping (NetworkResult<Any>) -> Void) {
        
        bithumbProvider.request(.getData(orderCurrency, paymentCurrency)) { result in
            switch result {
            case.success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data)
                completion(networkResult)
                
            case.failure(let error):
                print(error)
            }
        }
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode {
        case 200:
            return isValidData(data: data)
        case 400..<500:
            return .pathErr
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    
    private func isValidData(data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(coinResponse.self, from: data) else {
            return .pathErr}
        
        return .success(decodedData)
        }
    }

