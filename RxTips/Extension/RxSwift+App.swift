//
//  RxSwift+App.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/06.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import RxSwift

extension ObservableType {
  
  func justEmpty<T>() -> Observable<T> {
    flatMap { _ in
      Observable.empty()
    }
  }
}

extension PrimitiveSequence {
  
  func justEmpty<T>() -> Observable<T> {
    asObservable().flatMap { _ in
      Observable.empty()
    }
  }
  
  func observeOnMainScheduler() -> PrimitiveSequence<Trait, Element> {
    observe(on: MainScheduler())
  }  
}

extension PrimitiveSequence where Trait == SingleTrait {
    
  func mapVoid() -> Single<Void> {
    map { _ in () }
  }
}

extension PrimitiveSequence where Trait == MaybeTrait {
  
  func mapVoid() -> Maybe<Void> {
    map { _ in () }
  }
  
  func filterError() -> Maybe<Element> {
    `catch` { _ in .empty() }
  }
}
