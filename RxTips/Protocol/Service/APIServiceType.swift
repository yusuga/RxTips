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
  
  func requestJSON() -> Single<UserModel> {
    return request()
      .map {
        """
        {
          "id": "\(UUID().uuidString)",
          "snake_case_key": 1,
          "address": {
            "id": "1",
            "address_num": 1
          }
        }
        """.data(using: .utf8)!
    }
    .map {
      try JSONDecoder().decode(UserModel.self, from: $0)
    }
  }
}
