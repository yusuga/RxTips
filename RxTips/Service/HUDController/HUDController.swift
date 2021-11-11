//
//  HUDController.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/06.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD
import Then

final class HUDController {
  
  private let _activityIndicator = ActivityIndicator()
  private var hud: HUD.Type { HUD.self }
  private let disposeBag = DisposeBag()
  
  init() {
    hud.dimsBackground = true
    
    // HUDの表示
    activityIndicator.asDriver()
      .drive(isLoadActive)
      .disposed(by: disposeBag)
  }
}

extension HUDController: HUDControllerType {
  
  var activityIndicator: ActivityIndicator {
    return _activityIndicator
  }
  
  var isLoadActive: Binder<ActivityIndicator.Model> {
    Binder(self) {
      $1.isLoading
        ? $0.showLoading(title: $1.title, subTitle: $1.subTitle)
        : $0.hide(animated: true, completion: nil)
    }
  }
  
  func showLoading(
    title: String?,
    subTitle: String?
  ) {
    show(content: .labeledProgress(title: title, subtitle: subTitle))
  }
  
  func updateLoading(
    title: String?,
    subTitle: String?
  ) {
    guard hud.isVisible else { return }
    showLoading(title: title, subTitle: subTitle)
  }
  
  func hide(
    animated: Bool,
    completion: ((Bool) -> Void)?
  ) {
    hud.hide(animated: animated, completion: completion)
  }
}

private extension HUDController {
    
  func show(content: HUDContentType) {
    hud.show(content)
  }
}

extension Observable {
  
  func showHUD(
    title: String? = nil,
    subTitle: String? = nil
  ) -> Observable<Element> {
    trackActivity(Self.hudController.activityIndicator, title: title, subTitle: subTitle)
  }
  
  func showHUDSingle(
    title: String? = nil,
    subTitle: String? = nil
  ) -> Single<Element> {
    trackActivity(Self.hudController.activityIndicator, title: title, subTitle: subTitle).asSingle()
  }
  
  func showHUDMaybe(
    title: String? = nil,
    subTitle: String? = nil
  ) -> Maybe<Element> {
    trackActivity(Self.hudController.activityIndicator, title: title, subTitle: subTitle).asMaybe()
  }
}

extension PrimitiveSequence {
  
  func showHUD(
    title: String? = nil,
    subTitle: String? = nil
  ) -> Observable<Element> {
    trackActivity(Self.hudController.activityIndicator, title: title, subTitle: subTitle)
  }
  
  func showHUDSingle(
    title: String? = nil,
    subTitle: String? = nil
  ) -> Single<Element> {
    trackActivity(Self.hudController.activityIndicator, title: title, subTitle: subTitle).asSingle()
  }
  
  func showHUDMaybe(
    title: String? = nil,
    subTitle: String? = nil
  ) -> Maybe<Element> {
    trackActivity(Self.hudController.activityIndicator, title: title, subTitle: subTitle).asMaybe()
  }
}
