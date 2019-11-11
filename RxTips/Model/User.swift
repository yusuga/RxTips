//
//  RealmObject.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/07.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import Foundation
import RealmSwift

protocol User {
  
  associatedtype A = Address

  var id: String { get }
  var snakeCaseKey: Int { get }
  var address: A { get }
}

struct UserModel: User {

  let id: String
  let snakeCaseKey: Int
  let address: AddressModel
}

extension UserModel: Codable {

  enum CodingKeys: String, CodingKey {
    case id
    case snakeCaseKey = "snake_case_key"
    case address = "address"
  }
}

extension UserModel: ObjectConvertible {

  typealias Result = UserObject
}

final class UserObject: Object, User {

  @objc dynamic var id = ""
  @objc dynamic var snakeCaseKey = 0
  @objc dynamic var address: AddressObject?

  override class func primaryKey() -> String? {
    return #keyPath(id)
  }
}

extension UserObject: ObjectConvertible, Codable {

  typealias Result = UserModel
  typealias CodingKeys = Result.CodingKeys
}
