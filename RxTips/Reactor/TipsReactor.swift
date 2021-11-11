//
//  TipsReactor.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/06.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

import Foundation
import RxSwift
import ReactorKit
import Then
import RxRealm
import RxOptional

final class TipsReactor: Reactor {
  
  let userID: String
  
  init(userID: String) {
    self.userID = userID
  }
  
  enum Action {
    case request
    case showNestedHUD
    case requestError
    case requestConfirmed
    case requestSelection
    case requestObject
    case requestJSON
    case upsertUser
    case deleteUser
    case convertResponseToModel
  }
  
  enum Mutation {
    case incrementRequestCount
    case setObjects([UserModel])
    case setUser(UserModel?)
  }
  
  struct State: Then {
    var requestCount = 0
    var objects = [UserModel]()
    var user: UserModel?
  }
  
  var initialState = State()
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .request:
      return Self.apiClient
        .request()
        .map { Mutation.incrementRequestCount }
        .showHUD() // 注釈
      /**
       # 注釈
       - Observable.usingを使用したHUD表示です。
       - usingはObservableと同じ生存期間を持つことができるObservableです。
       - hudServiceが内部で依存しているActivityIndicatorはこのusingを利用して
       リソースの確保時(subscribe)と解放時(dispose)に内部の呼び出し回数を変数でインクリメント/デクリメントして管理しており、
       その変数が1以上の場合はisLoadingがtrueになります。
       - hudServiceはisLoadintgの変化をサブスクライブしてHUDの表示/非表示を切り替えています。
       - 参考:
       http://reactivex.io/documentation/operators/using.html
       https://qiita.com/k5n/items/e80ab6bff4bbb170122d#using
       */
      
    case .showNestedHUD:
      return Single.just(())
        .flatMap {
          Single.just(())
            .delay(RxTimeInterval.seconds(2), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOnMainScheduler()
            .showHUDSingle(title: "ネストしたHUD")
        }
        .flatMap {
          Single.just(())
            .delay(RxTimeInterval.seconds(1), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOnMainScheduler()
            .showHUDSingle(title: "タイトルを更新 1/3", subTitle: "サブタイトル 1/3")
        }
        .flatMap {
          Single.just(())
            .delay(RxTimeInterval.seconds(1), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOnMainScheduler()
            .showHUDSingle(title: "タイトルを更新 2/3", subTitle: "サブタイトル 2/3")
        }
        .flatMap {
          Single.just(())
            .delay(RxTimeInterval.seconds(1), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOnMainScheduler()
            .showHUDSingle(title: "タイトルを更新 3/3", subTitle: "サブタイトル 3/3")
        }
        .flatMap {
          Single.just(())
            .delay(RxTimeInterval.seconds(1), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOnMainScheduler()
            .showHUDSingle()
        }
        .flatMap {
          Single.just(())
            .delay(RxTimeInterval.seconds(1), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOnMainScheduler()
            .showHUDSingle(title: "nilの後に更新", subTitle: "サブタイトル")
        }
        .showHUD()
        .justEmpty()
      
    case .requestError:
      return Self.apiClient
        .requestError()
        .map { Mutation.incrementRequestCount }
        .showHUD(title: "リクエスト中", subTitle: "エラーが発生する")
        .showAlertIfCatchError() // 注釈
      /**
       # 注釈
       - catchErrorをラップしたもので、ストリームにerrorが流れてきたら
       alertServiceがアラートを表示します。nextはそのまま通過します。
       */
      
    case .requestConfirmed:
      return Self.alertController
        .showConfirmAlert(title: "リクエストしますか？")
        .flatMap {
          Self.apiClient.request()
            .showHUDMaybe(title: "リクエスト中", subTitle: "flatMap内") // 注釈1
        }
        .flatMap {
          Self.alertController.show(
            title: "成功",
            actions: [DoneAlertAction.done(nil)]
          )
        }
        .asObservable()
        .showAlertIfCatchError()
        .justEmpty() // 注釈2
      /**
       # 注釈1
       - flatMap内のObservableがsubscribeされるときにHUDが表示される
       # 注釈2
       - Observable.empty()をラップしたもので、イベントを流す必要がない場合に使用するシンタックスシュガー
       */
      
    case .requestSelection:
      return Self.alertController
        .show(
          title: "何をリクエストしますか？",
          preferredStyle: .actionSheet,
          actions: APIClientAction.allCases
        )
        .compactMap { $0.requestType }
        .flatMap {
          $0.execute()
            .showHUDMaybe(title: "リクエスト中", subTitle: "flatMap内")
        }
        .flatMap {
          Self.alertController.show(
            title: "成功",
            actions: [DoneAlertAction.done(nil)]
          )
        }
        .asObservable()
        .showAlertIfCatchError()
        .justEmpty()
      
    case .requestObject:
      return Self.apiClient.requestObject()
        .flatMap(Self.store.add())
        .showHUD()
        .showAlertIfCatchError()
        .justEmpty() // 注釈
      /**
       # 注釈
       - Realmに保存するがこのストリームではstateの更新を行わない。Realmへの変更は `transform(mutation:)` で監視する。
       */
      
    case .requestJSON:
      return Self.apiClient.requestJSON()
        .flatMap(Self.store.add())
        .showHUD()
        .showAlertIfCatchError()
        .justEmpty()
      
    case .upsertUser:
      return Observable.just(currentState.user)
        .replaceNilWith(
          UserModel(
            id: userID,
            snakeCaseKey: 1,
            address: AddressModel(
              id: UUID().uuidString,
              addressNum: 1
            )
          )
        )
        .map {
          $0.with {
            $0.snakeCaseKey = Int.random(in: 0...Int.max)
          }
        }
        .flatMap(Self.store.add())
        .showAlertIfCatchError()
        .justEmpty()
    case .deleteUser:
      return Self.store.fetch(UserObject.self, forPrimaryKey: userID)
        .asObservable()
        .errorOnNil(
          AppError.failed(
            title: "削除できません",
            description: "user.id == \(userID)はデータベースに存在しません。"
          )
        )
        .flatMap(Self.store.delete())
        .showAlertIfCatchError()
        .justEmpty()
    case .convertResponseToModel:
      let response = UserResponse(
        id: UUID().uuidString,
        snakeCaseKey: Int.random(in: 0...Int.max),
        addressID: UUID().uuidString,
        addressNum: Int.random(in: 0...Int.max)
      )
      return Observable.just(response)
        .map { try $0.convert() }
        .filter { model in
          guard
            model.id == response.id,
            model.snakeCaseKey == response.snakeCaseKey,
            model.address.id == response.addressID,
            model.address.addressNum == response.addressNum
          else {
            throw AppError.failed(title: "変換できていません", description: "response: \(response), model: \(model)")
          }
          return true
        }
        .debug()
        .showAlertIfCatchError()
        .justEmpty()
    }
  }
  
  func transform(mutation: Observable<TipsReactor.Mutation>) -> Observable<TipsReactor.Mutation> {
    let userID = self.userID
    
    return Observable.merge(
      mutation,
      
      // Realmに保存されているUserObjectが変更されたらイベントが流れます
      Self.store.fetch(UserObject.self)
        .map { try $0.map { try $0.convert() } } // 注釈
        .map(Mutation.setObjects)
        .showAlertIfCatchError(),
      
      Self.store.fetch(UserObject.self)
        .map { $0.filter { $0.id == userID } }
        .map { try $0.first?.convert() }
        .map(Mutation.setUser)
        .showAlertIfCatchError()
    )
    /**
     # 注釈
     - stateがそのままManaged UserObjectを直接参照してもいいのですが、
     以下の理由によりUI側は変換コストがかかったとしてもStructなど不変なオブジェクトを扱った方が設計として安全になります。
     
     ## 変換理由
     1. RealmSwift.Objectは異なるThreadをまたげない
     2. state.objectsをProtocolにして、RealmSwift.Objectのsetterを隠蔽して変換できないようにしている(もしも変更するときはRealmのトランザクションが必要)。
     ただ、1の理由があるため変換した方が安全
     
     - ちなみに上記のconvert部分をコメントアウトしても動作します。
     */
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    return state.with { state in
      switch mutation {
      case .incrementRequestCount:
        state.requestCount += 1
      case .setObjects(let objects):
        state.objects = objects
      case .setUser(let user):
        state.user = user
      }
    }
  }
}
