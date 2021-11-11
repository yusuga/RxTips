//
//  HUDControllerType.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/06.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol HUDControllerType: AnyObject {
  
  var activityIndicator: ActivityIndicator { get }
  var isLoadActive: Binder<ActivityIndicator.Model> { get }
  
  func showLoading(
    title: String?,
    subTitle: String?
  )
  
  func updateLoading(
    title: String?,
    subTitle: String?
  )
  
  func hide(
    animated: Bool,
    completion: ((Bool) -> Void)?
  )
}
