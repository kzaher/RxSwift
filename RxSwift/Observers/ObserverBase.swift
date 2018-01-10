//
//  ObserverBase.swift
//  RxSwift
//
//  Created by Krunoslav Zaher on 2/15/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

class ObserverBase<ElementType> : Disposable, ObserverType {
    typealias E = ElementType

    private var _isStopped: AtomicInt = 0

    func on(_ event: Event<E>) {
        switch event {
        case .next:
            if _isStopped == 0 {
                onCore(event)
            }
        case .error, .completed:
            if AtomicCompareAndSwap(0, 1, &_isStopped) {
                onCore(event)
            }
        }
    }

    func onCore(_ event: Event<E>) {
        rxAbstractMethod()
    }

    override func dispose() {
        _ = AtomicCompareAndSwap(0, 1, &_isStopped)
    }
}

func ensureSequenceGrammar<E>(_ observer: @escaping (Event<E>) -> ()) -> (Event<E>) -> () {
    var _isStopped: AtomicInt = 0

    return { event in
        switch event {
        case .next:
            if _isStopped == 0 {
                observer(event)
            }
        case .error, .completed:
            if AtomicCompareAndSwap(0, 1, &_isStopped) {
                observer(event)
            }
        }
    }
}
