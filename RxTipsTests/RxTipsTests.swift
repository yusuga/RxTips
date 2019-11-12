//
//  RxTipsTests.swift
//  RxTipsTests
//
//  Created by Yu Sugawara on 2019/11/12.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import XCTest
@testable import RxTips
import Quick
import Nimble
import RealmSwift

class RxTipsTests: QuickSpec {
  
  override func spec() {
    let sources: [(description: String, source: Data, answer: Data)] = [
      ("すべて値があるJSON", Helper.jsonWithFill, Helper.jsonWithFill),
//      ("nullを含むJSON", Helper.jsonWithNull(isNullKeyRemoved: false), Helper.jsonWithNull(isNullKeyRemoved: true)),
//      ("複雑なJSON", Helper.complexJSON, Helper.complexJSONAnswer)
    ]
    let objectTypes = [RealmObject.self, SubRealmObject.self]
    
    describe("ObjectConvertible") {
      sources.forEach { (description, source, answer) in
        #if false
        print("json: \(String(data: source, encoding: .utf8)!)")
        #endif
          context(description) {
            var realm: Realm!
            beforeEach {
              realm = try! Realm(
                configuration: Realm.Configuration(
                  inMemoryIdentifier: UUID().uuidString,
                  objectTypes: objectTypes
                )
              )
            }
            
            it("JSONのフォーマットは正しいか") {
              expect {
                try JSONSerialization.jsonObject(
                  with: source,
                  options: []
                )
              }
              .toNot(throwError())
              
              expect {
                try JSONSerialization.jsonObject(
                  with: answer,
                  options: []
                )
              }
              .toNot(throwError())
            }
            
            func createSwiftObject() throws -> SwiftObject {
              return try Helper.decoder.decode(SwiftObject.self, from: source)
            }
            
            func createRealmObject() throws -> RealmObject {
              return try Helper.decoder.decode(RealmObject.self, from: source)
            }
            
            func addObjectToRealm(_ object: RealmObject) throws -> RealmObject {
              try realm.write {
                realm.add(object)
              }
              return object
            }
            
            it("Structを生成できるか") {
              expect {
                try createSwiftObject()
              }
              .toNot(throwError())
            }
            
            it("RealmObjectを生成できるか") {
              expect {
                try createRealmObject()
              }
              .toNot(throwError())
            }
            
            it("RealmObjectをRealmに保存可能か") {
              expect {
                try addObjectToRealm(createRealmObject())
              }
              .toNot(throwError())
            }
            
            it("Structからjsonを生成できるか") {
              guard let swiftObj = try? createSwiftObject() else { fail(); return }
              
              expect {
                try expect(Helper.equalJSON(answer, to: swiftObj.json()))
                  .to(beTrue())
              }
              .toNot(throwError())
            }
            
            it("RealmSwift.Objectからjsonを生成できるか") {
              guard let realmObj = try? createRealmObject() else { fail(); return }
              
              expect {
                try expect(Helper.equalJSON(answer, to: realmObj.json()))
                  .to(beTrue())
              }
              .toNot(throwError())
            }
            
            it("Managed RealmObjectからjsonを生成できるか") {
              guard let realmObj = try? addObjectToRealm(createRealmObject()) else { fail(); return }

              expect {
                try expect(Helper.equalJSON(answer, to: realmObj.json()))
                  .to(beTrue())
              }
              .toNot(throwError())
            }
            
            it("FetchしたManaged RealmObjectからjsonを生成できるか") {
              guard let primaryID = try? addObjectToRealm(createRealmObject()).string,
                let realmObj = realm.object(ofType: RealmObject.self, forPrimaryKey: primaryID)
                else { fail(); return }
              
              expect {
                try expect(Helper.equalJSON(answer, to: realmObj.json()))
                  .to(beTrue())
              }
              .toNot(throwError())
            }
            
            it("StructをRealmObjectに変換可能か") {
              guard let swiftObj = try? createSwiftObject() else { fail(); return }
              
              expect {
                try expect(Helper.equalJSON(answer, to: swiftObj.convert().json()))
                  .to(beTrue())
              }
              .toNot(throwError())
            }
            
            it("RealmObjectをStructに変換可能か") {
              guard let realmObj = try? createRealmObject() else { fail(); return }

              expect {
                try expect(Helper.equalJSON(answer, to: realmObj.convert().json()))
                  .to(beTrue())
              }
              .toNot(throwError())
            }
            
            it("Managed RealmObjectをStructに変換可能か") {
              guard let realmObj = try? addObjectToRealm(createRealmObject()) else { fail(); return }
              
              expect {
                try expect(Helper.equalJSON(answer, to: realmObj.convert().json()))
                  .to(beTrue())
              }
              .toNot(throwError())
            }
            
            it("FetchしたManaged RealmObjectをStructに変換可能か") {
              guard let primaryID = try? addObjectToRealm(createRealmObject()).string,
                let realmObj = realm.object(ofType: RealmObject.self, forPrimaryKey: primaryID)
                else { fail(); return }
              
              expect {
                try expect(Helper.equalJSON(answer, to: realmObj.convert().json()))
                  .to(beTrue())
              }
              .toNot(throwError())
            }
        }
      }
    }
    
    describe("Helper") {
      let sources: [(description: String, source: String, answer: String)] = [
        ("空", "{}", "{}"),
        ("ソート", #"{"3":"3","2":[{"3":"3","2":"2","1":"1"},{"3":"3","2":"2","1":"1"}],"1":{"3":"3","2":[{"3":"3","2":"2","1":"1"},{"3":"3","2":"2","1":"1"}],"1":{"3":"3","2":[{"3":"3","2":"2","1":"1"},{"3":"3","2":"2","1":"1"}],"1":{"3":"3","2":[{"3":"3","2":"2","1":"1"},{"3":"3","2":"2","1":"1"}],"1":"1"}}}}"#, #"{"1":{"1":{"1":{"1":"1","2":[{"1":"1","2":"2","3":"3"},{"1":"1","2":"2","3":"3"}],"3":"3"},"2":[{"1":"1","2":"2","3":"3"},{"1":"1","2":"2","3":"3"}],"3":"3"},"2":[{"1":"1","2":"2","3":"3"},{"1":"1","2":"2","3":"3"}],"3":"3"},"2":[{"1":"1","2":"2","3":"3"},{"1":"1","2":"2","3":"3"}],"3":"3"}"#),
        ("nullを削除", #"{"3":null,"2":null,"1":{"3":null,"2":[{"3":null,"2":null,"1":"1"},{"3":null,"2":null,"1":null}],"1":{"3":null,"2":null,"1":null}}}"#, #"{"1":{"1":{},"2":[{"1":"1"},{}]}}"#)
      ]
      
      context("removeNullAndSortedFromJSON(_:)") {
        sources.forEach { description, source, answer in
          it(description) {
            let sourceData = try! JSONSerialization.data(
              withJSONObject: JSONSerialization.jsonObject(
                with: source.data(using: .utf8)!,
                options: []
              ),
              options: []
            )
            let answerData = try! JSONSerialization.data(
              withJSONObject: JSONSerialization.jsonObject(
                with: answer.data(using: .utf8)!,
                options: []
              ),
              options: []
            )
            expect(Helper.removeNullAndSortedFromJSON(sourceData) == answerData).to(beTrue())
          }
        }
      }
    }
  }
}
