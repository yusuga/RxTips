//
//  RxSwift+Tips.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/06.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import RxSwift

extension ObservableType {
  
  func justEmpty<T>() -> Observable<T> {
    return flatMap { _ in
      return Observable.empty()
    }
  }
}

extension PrimitiveSequence {
  
  func justEmpty<T>() -> Observable<T> {
    return asObservable().flatMap { _ in
      return Observable.empty()
    }
  }
}
