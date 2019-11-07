//
//  APIService.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/06.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import RxSwift

final class APIService {
  
}

extension APIService: APIServiceType {
  
  func request() -> Single<Void> {
    return Single.just(())
      .delay(
        RxTimeInterval.seconds(1),
        scheduler: ConcurrentDispatchQueueScheduler(qos: .default)
      )
      .observeOn(MainScheduler.instance)
  }  
}
