//
//  APIServiceType.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/06.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import RxSwift

protocol APIServiceType {
  
  func request() -> Single<Void>
}

extension APIServiceType {
  
  func requestError() -> Single<Void> {
    return request()
      .map { throw AppError.failed(title: "リクエストエラー", description: nil) }
  }
  
  func requestObject() -> Single<UserModel> {
    return request()
      .map {
        UserModel(
          id: UUID().uuidString,
          snakeCaseKey: 1,
          address: AddressModel(
            id: UUID().uuidString,
            addressNum: 1
          )
        )
    }
  }
}
