//
//  ServiceContainerType.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/06.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import Foundation
import URLNavigator

protocol ServiceContainerType {
  
  var navigator: NavigatorType { get }
  var alertService: AlertServiceType { get }
  var hudService: HUDServiceType { get }
}
