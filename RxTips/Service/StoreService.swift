//
//  StoreService.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/07.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import Foundation
import RealmSwift

final class StoreService {
  
  private let configure: Realm.Configuration
  
  init(configure: Realm.Configuration) {
    self.configure = configure
  }
}

extension StoreService: StoreServiceType {
  
  func realm() throws -> Realm {
    return try Realm(configuration: configure)
  }
}
