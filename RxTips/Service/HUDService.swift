//
//  HUDService.swift
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

final class HUDService {
  
  private let _activityIndicator = ActivityIndicator()
  private let hud = PKHUD().then {
    $0.dimsBackground = true
  }
  private let disposeBag = DisposeBag()
  
  func showLoading() {
    show(contentView: PKHUDProgressView())
  }
  
  func hide(animated: Bool) {
    hide(animated: animated, completion: nil)
  }
  
  init() {
    // HUDの表示
    activityIndicator.asDriver()
      .drive(isLoadActive)
      .disposed(by: disposeBag)
  }
}

extension HUDService: HUDServiceType {
  
  var activityIndicator: ActivityIndicator {
    return _activityIndicator
  }
  
  func show(contentView: UIView) {
    hud.contentView = contentView
    hud.show()
  }
  
  func hide(animated: Bool, completion: ((Bool) -> Void)?) {
    hud.hide(animated, completion: completion)
  }
  
  var isLoadActive: Binder<Bool> {
    return Binder(self) {
      $1 ? $0.showLoading() : $0.hide(animated: false, completion: nil)
    }
  }
}
