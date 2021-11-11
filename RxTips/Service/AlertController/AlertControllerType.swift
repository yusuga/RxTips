//
//  AlertControllerType.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/06.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import UIKit
import RxSwift
import URLNavigator

protocol AlertControllerType: AnyObject {
  
  func show<Action: AlertActionType>(
    title: String?,
    message: String?,
    preferredStyle: UIAlertController.Style,
    actions: [Action],
    textFieldConfigurationHandlers: [(UITextField) -> Void]?
  ) -> Maybe<Action>
}

extension AlertControllerType {
  
  func show<Action: AlertActionType>(
    title: String?,
    message: String? = nil,
    preferredStyle: UIAlertController.Style = .alert,
    actions: [Action],
    textFieldConfigurationHandlers: [(UITextField) -> Void]? = nil
  ) -> Maybe<Action> {
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

extension Observable {
  
  func showAlertIfCatchError() -> Observable<Element> {
    return `catch` { error in
      return Self.alertController.showError(error)
        .asObservable()
        .flatMap { Observable.empty() }
    }
  }
}
