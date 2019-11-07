//
//  Foundation+Tips.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/07.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import Foundation
import Then

extension JSONEncoder: Then {}
extension JSONEncoder {
  
  static var `default`: JSONEncoder {
    return JSONEncoder().then {
      $0.dateEncodingStrategy = .iso8601
    }
  }
}

extension JSONDecoder: Then {}
extension JSONDecoder {
  
  static var `default`: JSONDecoder {
    return JSONDecoder().then {
      $0.dateDecodingStrategy = .iso8601
    }
  }
}
