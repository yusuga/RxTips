//
//  ActivityIndicator.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/06.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//
//  https://github.com/ReactiveX/RxSwift/blob/d6dfcfa/RxExample/RxExample/Services/ActivityIndicator.swift

import Foundation
import RxSwift
import RxCocoa
import Then

private struct ActivityToken<E>: ObservableConvertibleType, Disposable {
  
  private let _source: Observable<E>
  private let _dispose: Cancelable
  
  init(
    source: Observable<E>,
    disposeAction: @escaping () -> Void
  ) {
    _source = source
    _dispose = Disposables.create(with: disposeAction)
  }
  
  func dispose() {
    _dispose.dispose()
  }
  
  func asObservable() -> Observable<E> {
    _source
  }
}

/**
 Enables monitoring of sequence computation.
 If there is at least one sequence computation in progress, `true` will be sent.
 When all activities complete `false` will be sent.
 */
public class ActivityIndicator: SharedSequenceConvertibleType {
  
  public typealias Element = Model
  public typealias SharingStrategy = DriverSharingStrategy
  
  public struct Model: Equatable, Then {
    var count: Int
    var isLoading: Bool { count > 0 } // swiftlint:disable:this empty_count
    let title: String?
    let subTitle: String?
  }
  
  private let _lock = NSRecursiveLock()
  private let _relay = BehaviorRelay(value: Model(count: 0, title: nil, subTitle: nil))
  private let _loading: SharedSequence<SharingStrategy, Element>
  
  public init() {
    _loading = _relay.asDriver()
      .distinctUntilChanged()
  }
  
  fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(
    _ source: O,
    title: String?,
    subTitle: String?
  ) -> Observable<O.Element> {
    Observable.using(
      _: { () -> ActivityToken<O.Element> in
        self.increment(title: title, subTitle: subTitle)
        return ActivityToken(source: source.asObservable(), disposeAction: self.decrement)
      },
      observableFactory: {
        $0.asObservable()
      }
    )
  }
  
  private func increment(
    title: String?,
    subTitle: String?
  ) {
    _lock.lock()
    _relay.accept(Model(count: _relay.value.count + 1, title: title, subTitle: subTitle))
    _lock.unlock()
  }
  
  private func decrement() {
    _lock.lock()
    _relay.accept(_relay.value.with { $0.count -= 1 })
    _lock.unlock()
  }
  
  public func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
    _loading
  }
}

extension ObservableConvertibleType {
  
  func trackActivity(
    _ activityIndicator: ActivityIndicator,
    title: String?,
    subTitle: String?
  ) -> Observable<Element> {
    activityIndicator.trackActivityOfObservable(self, title: title, subTitle: subTitle)
  }
}
