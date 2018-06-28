//
//  MusicListViewModel.swift
//  Lesson-RxSwift
//
//  Created by jinjin on 2018/6/28.
//  Copyright © 2018年 jinjin. All rights reserved.
//

import Foundation
import RxSwift

struct MusicListViewModel {
    let data = Observable.just([Music(name: "无条件", singer: "陈奕迅"),
                                Music(name: "你曾是少年", singer: "S.H.E"),
                                Music(name: "从前的我", singer: "陈洁仪"),
                                Music(name: "在木星", singer: "朴树")])
    let obs = Observable.repeatElement(1)
    let obs1 = Observable.generate(initialState: 0, condition: { $0 <= 10
    }) {
        $0 + 2
    }
    
    let obs2 = Observable<String>.create { (observer) -> Disposable in
        observer.onNext("hangge.com")
        observer.onCompleted()
        return Disposables.create()
        }.subscribe {
            print($0)
    }
    
    
}
