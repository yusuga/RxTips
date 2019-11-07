//
//  HUDServiceType.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/06.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol HUDServiceType: class {
  
  var activityIndicator: ActivityIndicator { get }
  
  func show(contentView: UIView)
  func hide(animated: Bool, completion: ((Bool) -> Void)?)
  
  var isLoadActive: Binder<Bool> { get }
}

extension ObservableConvertibleType {
  
  func trackActivity(_ hudService: HUDServiceType) -> Observable<Self.Element> {
    return trackActivity(hudService.activityIndicator)
  }
  
  func trackActivitySingle(_ hudService: HUDServiceType) -> Single<Self.Element> {
    return trackActivity(hudService.activityIndicator).asSingle()
  }
  
  func trackActivityMaybe(_ hudService: HUDServiceType) -> Maybe<Self.Element> {
    return trackActivity(hudService.activityIndicator).asMaybe()
  }
}
