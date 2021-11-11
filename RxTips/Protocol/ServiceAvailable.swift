//
//  ServiceAvailable.swift
//  RxTips
//
//  Created by yusuga on 2021/11/10.
//  Copyright © 2021 Yu Sugawara. All rights reserved.
//

import Foundation

@dynamicMemberLookup
protocol ServiceAvailable {
  
  associatedtype Container
  static subscript<T>(dynamicMember keyPath: KeyPath<Container, T>) -> T { get }
}
