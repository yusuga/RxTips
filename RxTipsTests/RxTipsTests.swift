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
    let objectTypes = [RealmObject.self, SubRealmObject.self, RealmOptObject.self]
    
    describe("ObjectConvertible RealmOptionalを含まないケース") {
      let sources: [(description: String, source: Data)] = [
        ("すべて値があるJSON", Helper.jsonWithFill),
        ("nullを含むJSON", Helper.jsonWithNull),
        ("複雑なJSON", Helper.complexJSON)
      ]
      
      func createSwiftObject(_ source: Data) throws -> SwiftObject {
        return try Helper.decoder.decode(SwiftObject.self, from: source)
      }
      
      func createRealmObject(_ source: Data) throws -> RealmObject {
        return try Helper.decoder.decode(RealmObject.self, from: source)
      }
      
      sources.forEach { (description, source) in
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
          
          func addObjectToRealm<O: Object>(_ object: O) throws -> O {
            try realm.write {
              realm.add(object)
            }
            return object
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
                with: source,
                options: []
              )
            }
            .toNot(throwError())
          }
          
          it("Structを生成できるか") {
            expect {
              try createSwiftObject(source)
            }
            .toNot(throwError())
          }
          
          it("RealmObjectを生成できるか") {
            expect {
              try createRealmObject(source)
            }
            .toNot(throwError())
          }
          
          it("RealmObjectをRealmに保存可能か") {
            expect {
              try addObjectToRealm(createRealmObject(source))
            }
            .toNot(throwError())
          }
          
          it("Structからjsonを生成できるか") {
            guard let swiftObj = try? createSwiftObject(source) else { fail(); return }
            
            expect {
              try expect(Helper.equalJSON(source, to: swiftObj.json()))
                .to(beTrue())
            }
            .toNot(throwError())
          }
          
          it("RealmSwift.Objectからjsonを生成できるか") {
            guard let realmObj = try? createRealmObject(source) else { fail(); return }
            
            expect {
              try expect(Helper.equalJSON(source, to: realmObj.json()))
                .to(beTrue())
            }
            .toNot(throwError())
          }
          
          it("Managed RealmObjectからjsonを生成できるか") {
            guard let realmObj = try? addObjectToRealm(createRealmObject(source)) else { fail(); return }
            
            expect {
              try expect(Helper.equalJSON(source, to: realmObj.json()))
                .to(beTrue())
            }
            .toNot(throwError())
          }
          
          it("FetchしたManaged RealmObjectからjsonを生成できるか") {
            guard let primaryID = try? addObjectToRealm(createRealmObject(source)).string,
              let realmObj = realm.object(ofType: RealmObject.self, forPrimaryKey: primaryID)
              else { fail(); return }
            
            expect {
              try expect(Helper.equalJSON(source, to: realmObj.json()))
                .to(beTrue())
            }
            .toNot(throwError())
          }
                    
          it("StructをRealmObjectに相互変換可能か") {
            guard let swiftObj = try? createSwiftObject(source) else { fail(); return }
            
            // convertを2回行うことでStruct → Realm → StructやRealm → Struct → Realmが成功しているかを確認している
            expect {
              try expect(Helper.equalJSON(source, to: swiftObj.convert().convert().json()))
                .to(beTrue())
            }
            .toNot(throwError())
          }
          
          it("RealmObjectをStructに相互変換可能か") {
            guard let realmObj = try? createRealmObject(source) else { fail(); return }
            
            expect {
              try expect(Helper.equalJSON(source, to: realmObj.convert().convert().json()))
                .to(beTrue())
            }
            .toNot(throwError())
          }
          
          it("Managed RealmObjectをStructに相互変換可能か") {
            guard let realmObj = try? addObjectToRealm(createRealmObject(source)) else { fail(); return }
            
            expect {
              try expect(Helper.equalJSON(source, to: realmObj.convert().convert().json()))
                .to(beTrue())
            }
            .toNot(throwError())
          }
          
          it("FetchしたManaged RealmObjectをStructに相互変換可能か") {
            guard let primaryID = try? addObjectToRealm(createRealmObject(source)).string,
              let realmObj = realm.object(ofType: RealmObject.self, forPrimaryKey: primaryID)
              else { fail(); return }
            
            expect {
              try expect(Helper.equalJSON(source, to: realmObj.convert().convert().json()))
                .to(beTrue())
            }
            .toNot(throwError())
          }
        }
      }
    }
    
    describe("ObjectConvertible RealmOptionalを含むケース") {
      let sources: [(description: String, source: Data, realmObjectAnswer: Data)] = [
        ("すべて値があるJSON", Helper.optJSONWithFill, Helper.optJSONWithFill),
        ("nullを含むJSON", Helper.optJSONWithNull, Helper.optJSONRealmObjectAnswerWithNull),
        ("キーが含まれていないJSON", Helper.optJSONWithDeletedOptionalKeys, Helper.optJSONRealmObjectAnswerWithNull)
      ]
      
      func createSwiftObject(_ source: Data) throws -> SwiftOptObject {
        return try Helper.decoder.decode(SwiftOptObject.self, from: source)
      }
      
      func createRealmObject(_ source: Data) throws -> RealmOptObject {
        return try Helper.decoder.decode(RealmOptObject.self, from: source)
      }
      
      // 以下はObjectConvertible RealmOptionalを含まないケースとほぼ同じことをテストしている。
      // うまく抽象化する方法が思いつかなかった。
      sources.forEach { (description, source, realmObjectAnswer) in
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
          
          func addObjectToRealm<O: Object>(_ object: O) throws -> O {
            try realm.write {
              realm.add(object)
            }
            return object
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
                with: source,
                options: []
              )
            }
            .toNot(throwError())
          }
          
          it("Structを生成できるか") {
            expect {
              try createSwiftObject(source)
            }
            .toNot(throwError())
          }
          
          it("RealmObjectを生成できるか") {
            expect {
              try createRealmObject(source)
            }
            .toNot(throwError())
          }
          
          it("RealmObjectをRealmに保存可能か") {
            expect {
              try addObjectToRealm(createRealmObject(source))
            }
            .toNot(throwError())
          }
          
          it("Structからjsonを生成できるか") {
            guard let swiftObj = try? createSwiftObject(source) else { fail(); return }
            
            expect {
              try expect(Helper.equalJSON(source, to: swiftObj.json()))
                .to(beTrue())
            }
            .toNot(throwError())
          }
          
          it("RealmSwift.Objectからjsonを生成できるか") {
            guard let realmObj = try? createRealmObject(source) else { fail(); return }
            
            let data = try! realmObj.json()
            print(String(data: data, encoding: .utf8)!)
            print(String(data: source, encoding: .utf8)!)
            
            expect {
              try expect(Helper.equalJSON(realmObjectAnswer, to: realmObj.json()))
                .to(beTrue())
            }
            .toNot(throwError())
          }
          
          it("Managed RealmObjectからjsonを生成できるか") {
            guard let realmObj = try? addObjectToRealm(createRealmObject(source)) else { fail(); return }
            
            expect {
              try expect(Helper.equalJSON(realmObjectAnswer, to: realmObj.json()))
                .to(beTrue())
            }
            .toNot(throwError())
          }
          
          it("FetchしたManaged RealmObjectからjsonを生成できるか") {
            guard let primaryID = try? addObjectToRealm(createRealmObject(source)).string,
              let realmObj = realm.object(ofType: RealmOptObject.self, forPrimaryKey: primaryID)
              else { fail(); return }
            
            expect {
              try expect(Helper.equalJSON(realmObjectAnswer, to: realmObj.json()))
                .to(beTrue())
            }
            .toNot(throwError())
          }
          
          it("StructをRealmObjectに相互変換可能か") {
            guard let swiftObj = try? createSwiftObject(source) else { fail(); return }
            
            expect {
              try expect(Helper.equalJSON(realmObjectAnswer, to: swiftObj.convert().convert().json()))
                .to(beTrue())
            }
            .toNot(throwError())
          }
          
          it("RealmObjectをStructに相互変換可能か") {
            guard let realmObj = try? createRealmObject(source) else { fail(); return }
            
            expect {
              try expect(Helper.equalJSON(realmObjectAnswer, to: realmObj.convert().convert().json()))
                .to(beTrue())
            }
            .toNot(throwError())
          }
          
          it("Managed RealmObjectをStructに相互変換可能か") {
            guard let realmObj = try? addObjectToRealm(createRealmObject(source)) else { fail(); return }
            
            expect {
              try expect(Helper.equalJSON(realmObjectAnswer, to: realmObj.convert().convert().json()))
                .to(beTrue())
            }
            .toNot(throwError())
          }
          
          it("FetchしたManaged RealmObjectをStructに相互変換可能か") {
            guard let primaryID = try? addObjectToRealm(createRealmObject(source)).string,
              let realmObj = realm.object(ofType: RealmOptObject.self, forPrimaryKey: primaryID)
              else { fail(); return }
            
            expect {
              try expect(Helper.equalJSON(realmObjectAnswer, to: realmObj.convert().convert().json()))
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
