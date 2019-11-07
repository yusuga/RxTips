//
//  AlertServiceType.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/06.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import UIKit
import RxSwift
import URLNavigator

protocol AlertActionType {
  
  var title: String? { get }
  var style: UIAlertAction.Style { get }
}

extension AlertActionType {
  
  var style: UIAlertAction.Style {
    return .default
  }
}

enum DoneAlertAction: AlertActionType {
  
  case done(String?)
  
  var title: String? {
    switch self {
    case .done(let string?): return string
    default: return "OK"
    }
  }
}

enum CancellableAlertAction: AlertActionType, Equatable {
  
  case ok(String)
  case cancel
  
  var title: String? {
    switch self {
    case .ok(let string): return string
    case .cancel: return "キャンセル"
    }
  }
  
  var style: UIAlertAction.Style {
    switch self {
    case .ok: return .default
    case .cancel: return .cancel
    }
  }
  
  var isOK: Bool {
    return CancellableAlertAction.cancel != self
  }
}

enum DestructibleAlertAction: AlertActionType {
  
  case destroy(String)
  case cancel(String)
  
  var title: String? {
    switch self {
    case .destroy(let title): return title
    case .cancel(let title): return title
    }
  }
  
  var style: UIAlertAction.Style {
    switch self {
    case .destroy: return .destructive
    case .cancel: return .cancel
    }
  }
  
  var isDestroyed: Bool {
    if case .destroy = self { return true }
    return false
  }
}

protocol AlertServiceType: class {
  
  func show<Action: AlertActionType>(
    title: String?,
    message: String?,
    preferredStyle: UIAlertController.Style,
    actions: [Action],
    textFieldConfigurationHandlers: [(UITextField) -> Void]?
    ) -> Maybe<Action>
}

extension AlertServiceType {
  
  func show<Action: AlertActionType>(
    title: String?,
    message: String? = nil,
    preferredStyle: UIAlertController.Style = .alert,
    actions: [Action],
    textFieldConfigurationHandlers: [(UITextField) -> Void]? = nil
    ) -> Maybe<Action>
  {
    return show(title: title, message: message, preferredStyle: preferredStyle, actions: actions, textFieldConfigurationHandlers: textFieldConfigurationHandlers)
  }
  
  func showError(_ error: Error) -> Maybe<Void> {
    return show(
      title: error.localizedDescription,
      message: (error as? LocalizedError)?.failureReason,
      preferredStyle: .alert,
      actions: [DoneAlertAction.done("OK")],
      textFieldConfigurationHandlers: nil
      )
      .map { _ in () }
  }
  
  func showConfirmAlert(
    title: String?,
    message: String? = nil,
    okTitle: String = "OK"
    ) -> Maybe<Void> {
    return show(
      title: title,
      message: message,
      actions: [CancellableAlertAction.cancel, .ok(okTitle)]
      )
      .filter { $0.isOK }
      .map { _ in () }
  }
}

extension ObservableType {
  
  func showAlertIfCatchError(_ alertService: AlertServiceType) -> Observable<Element> {
    return catchError { error in
      return alertService.showError(error)
        .asObservable()
        .flatMap { Observable.empty() }
    }
  }
}
