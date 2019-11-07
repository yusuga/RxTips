//
//  AlertService.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/06.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import UIKit
import URLNavigator
import RxSwift

final class AlertService: AlertServiceType {
  
  struct Dependency {
    let navigator: NavigatorType
  }
  
  private let dependency: Dependency
  
  init(dependency: Dependency) {
    self.dependency = dependency
  }
  
  func show<Action: AlertActionType>(
    title: String?,
    message: String?,
    preferredStyle: UIAlertController.Style,
    actions: [Action],
    textFieldConfigurationHandlers: [(UITextField) -> Void]?
    ) -> Maybe<Action> {
    
    return Maybe.create { [unowned self] observer -> Disposable in
      let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
      
      actions.forEach { action in
        alert.addAction(UIAlertAction(title: action.title, style: action.style) { _ in
          observer(.success(action))
        })
      }
      
      textFieldConfigurationHandlers?.forEach {
        alert.addTextField(configurationHandler: $0)
      }
      
      if self.dependency.navigator.present(alert) == nil {
        observer(.error(AppError.navigatorError))
        return Disposables.create()
      }
      
      return Disposables.create {
        alert.dismiss(animated: true)
      }
    }
  }
}
