//
//  RealmObject.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/07.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import Foundation
import RealmSwift
import Then

struct UserModel {

  let id: String
  var snakeCaseKey: Int
  let address: AddressModel
  let value = Defines.defaultValue
}

extension UserModel: Codable {

  enum CodingKeys: String, CodingKey {
    case id
    case snakeCaseKey = "snake_case_key"
    case address = "address"
    case value = "value"
  }
}

extension UserModel: ObjectConvertible {

  typealias Result = UserObject
}

extension UserModel: Then { }

final class UserObject: Object {

  @objc dynamic var id = ""
  @objc dynamic var snakeCaseKey = 0
  @objc dynamic var address: AddressObject?
  @objc dynamic var value = ""

  override class func primaryKey() -> String? {
    return #keyPath(id)
  }
}

extension UserObject: ObjectConvertible, Codable {

  typealias Result = UserModel
  typealias CodingKeys = Result.CodingKeys
}

struct UserResponse {
  
  let id: String
  let snakeCaseKey: Int
  let addressID: String
  let addressNum: Int
}

extension UserResponse: ObjectConvertible {

  typealias Result = UserModel
}

extension ObjectConvertible where Self == UserResponse {
  
  func convert() throws -> UserModel {
    return UserModel(
      id: self.id,
      snakeCaseKey: self.snakeCaseKey,
      address: AddressModel(
        id: self.addressID,
        addressNum: self.addressNum
      )
    )
  }
}
