//
//  AlertActionType.swift
//  RxTips
//
//  Created by yusuga on 2021/11/10.
//  Copyright © 2021 Yu Sugawara. All rights reserved.
//

import UIKit

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
