//
//  APIManager.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/3/14.
//

import Foundation
import Moya
import ObjectMapper
import RxSwift
import Alamofire
import RxMoya


protocol MappableResponseTargetType: TargetType {
    associatedtype ResponseType: Mappable
}


final public class APIManager {
    
    public static let shared = APIManager()
    
    private init() {}
    private let provider = MoyaProvider<MultiTarget>()
    
    /// 請求回傳特定Model Type
    func request<Request: MappableResponseTargetType>(_ request: Request) -> Single<Request.ResponseType> {
        let target = MultiTarget.init(request)
        return provider.rx.request(target)
            .timeout(.seconds(10), scheduler: MainScheduler.instance)
            .filterSuccessfulStatusCodes()
            .mapObject(Request.ResponseType.self)// 在此會解析 Response，具體怎麼解析，交由 data model 的 decodable 去處理。
    }
    
    
}
