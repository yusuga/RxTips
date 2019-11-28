//
//  TipsReactor.swift
//  RxTips
//
//  Created by Yu Sugawara on 2019/11/06.
//  Copyright © 2019 Yu Sugawara. All rights reserved.
//

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
    case requestError
    case requestConfirmed
    case requestObject
    case requestJSON
    case upsertUser
    case deleteUser
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
      return apiService
        .request()
        .map { Mutation.incrementRequestCount }
        .asObservable()
        .trackActivity(hudService) // 注釈
        .showAlertIfCatchError(alertService)
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
      
    case .requestError:
      return apiService
        .requestError()
        .map { Mutation.incrementRequestCount }
        .asObservable()
        .trackActivity(hudService)
        .showAlertIfCatchError(alertService) // 注釈
      /**
       # 注釈
       - catchErrorをラップしたもので、ストリームにerrorが流れてきたら
       alertServiceがアラートを表示します。nextはそのまま通過します。
       */
      
    case .requestConfirmed:
      return alertService
        .showConfirmAlert(title: "リクエストしますか？")
        .flatMap { [unowned self] _ in
          self.apiService.request()
            .trackActivity(self.hudService) // 注釈1
            .asMaybe()
      }
      .flatMap { [unowned self] in
        self.alertService.show(
          title: "成功",
          actions: [DoneAlertAction.done(nil)]
        )
      }
      .asObservable()
      .showAlertIfCatchError(alertService)
        .justEmpty() // 注釈2      
      /**
       # 注釈1
       - flatMap内のObservableがsubscribeされるときにHUDが表示される
       # 注釈2
       - Observable.empty()をラップしたもので、イベントを流す必要がない場合に使用するシンタックスシュガー
       */
      
    case .requestObject:
      return apiService.requestObject()
        .flatMap(storeService.add())
        .trackActivity(hudService)
        .showAlertIfCatchError(alertService)
        .justEmpty() // 注釈
      /**
       # 注釈
       - Realmに保存するがこのストリームではstateの更新を行わない。Realmへの変更は `transform(mutation:)` で監視する。
       */
      
    case .requestJSON:
      return apiService.requestJSON()
      .flatMap(storeService.add())
      .trackActivity(hudService)
      .showAlertIfCatchError(alertService)
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
      .flatMap(storeService.add())
      .showAlertIfCatchError(alertService)
      .justEmpty()
    case .deleteUser:      
      return storeService.fetch(UserObject.self, forPrimaryKey: userID)
        .asObservable()
        .errorOnNil(
          AppError.failed(
            title: "削除できません",
            description: "user.id == \(userID)はデータベースに存在しません。"
          )
      )
        .flatMap(storeService.delete())
        .showAlertIfCatchError(alertService)
        .justEmpty()
    }    
  }
  
  func transform(mutation: Observable<TipsReactor.Mutation>) -> Observable<TipsReactor.Mutation> {
    let userID = self.userID
    
    return Observable.merge(
      mutation,
      
      // Realmに保存されているUserObjectが変更されたらイベントが流れます
      storeService.fetch(UserObject.self)
        .map { try $0.map { try $0.convert() } } // 注釈
        .map(Mutation.setObjects)
        .showAlertIfCatchError(alertService),
      
      storeService.fetch(UserObject.self)
        .map { $0.filter { $0.id == userID } }
        .map { try $0.first?.convert() }
        .map(Mutation.setUser)
        .showAlertIfCatchError(alertService)
    )
    /**
     # 注釈
     - stateがそのままManaged UserObjectを直接参照してもいいのですが、
     以下の理由によりUI側は変換コストがかかったとしてもStructなど普遍なオブジェクトを扱った方が設計として安全になります。
     
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
