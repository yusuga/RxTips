//
//  AppError.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/06.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import Foundation

enum AppError: LocalizedError {
  
  case failed(title: String, description: String?)
  
  var localizedDescription: String {
    switch self {
    case .failed(let title, _):
      return title
    }
  }
  
  var errorDescription: String? {
    return localizedDescription
  }
  
  var failureReason: String? {
    switch self {
    case .failed(_, let description):
      return description
    }
  }
}

extension AppError {
  
  static func logicError(description: String) -> AppError {
    return .failed(
      title: "Logic failure",
      description: description
    )
  }
  
  static var navigatorError: AppError {
    return .logicError(description: "Navigate failed")
  }  
}
