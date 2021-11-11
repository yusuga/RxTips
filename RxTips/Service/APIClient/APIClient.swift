//
//  APIClient.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/06.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import UIKit
import RxSwift

final class APIClient {}

extension APIClient: APIClientType {
  
  func request() -> Single<Void> {
    return Single.just(())
      .delay(
        RxTimeInterval.seconds(1),
        scheduler: ConcurrentDispatchQueueScheduler(qos: .default)
      )
      .observe(on: MainScheduler.instance)
  }  
}

enum APIRequestType: CaseIterable {
  
  case request
  case requestError
  
  var title: String {
    switch self {
    case .request:
      return "通常リクエスト"
    case .requestError:
      return "エラーが発生するリクエスト"
    }
  }
  
  func execute() -> Single<Void> {
    switch self {
    case .request:
      return Self.apiClient.request()
    case .requestError:
      return Self.apiClient.requestError()
    }
  }
}

enum APIClientAction: AlertActionType, CaseIterable {
  case request(APIRequestType)
  case cancel
  
  var title: String? {
    switch self {
    case let .request(type):
      return type.title
    case .cancel:
      return "キャンセル"
    }
  }
  
  var style: UIAlertAction.Style {
    switch self {
    case .request:
      return .default
    case .cancel:
      return .cancel
    }
  }
  
  var requestType: APIRequestType? {
    switch self {
    case let .request(type):
      return type
    case .cancel:
      return nil
    }
  }
  
  static var allCases: [APIClientAction] {
    APIRequestType.allCases.map { APIClientAction.request($0) }
    + [.cancel]
  }
}
