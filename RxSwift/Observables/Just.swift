//
//  Just.swift
//  RxSwift
//
//  Created by Krunoslav Zaher on 8/30/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

extension ObservableType {
    /**
     Returns an observable sequence that contains a single element.

     - seealso: [just operator on reactivex.io](http://reactivex.io/documentation/operators/just.html)

     - parameter element: Single element in the resulting observable sequence.
     - returns: An observable sequence containing the single specified element.
     */
    public static func just(_ element: Element) -> Observable<Element> {
        return Just(element: element)
    }

    /**
     Returns an observable sequence that contains a single element.

     - seealso: [just operator on reactivex.io](http://reactivex.io/documentation/operators/just.html)

     - parameter element: Single element in the resulting observable sequence.
     - parameter scheduler: Scheduler to send the single element on.
     - returns: An observable sequence containing the single specified element.
     */
    public static func just(_ element: Element, scheduler: ImmediateSchedulerType) -> Observable<Element> {
        return JustScheduled(element: element, scheduler: scheduler)
    }
}

final private class JustScheduledSink<O: ObserverType>: Sink<O> {
    typealias Parent = JustScheduled<O.Element>

    private let _parent: Parent

    init(parent: Parent, observer: O, cancel: Cancelable) {
        self._parent = parent
        super.init(observer: observer, cancel: cancel)
    }

    func run() -> Disposable {
        let scheduler = self._parent._scheduler
        return scheduler.schedule(self._parent._element) { element in
            self.forwardOn(.next(element))
            return scheduler.schedule(()) { _ in
                self.forwardOn(.completed)
                self.dispose()
                return Disposables.create()
            }
        }
    }
}

final private class JustScheduled<Element>: Producer<Element> {
    fileprivate let _scheduler: ImmediateSchedulerType
    fileprivate let _element: Element

    init(element: Element, scheduler: ImmediateSchedulerType) {
        self._scheduler = scheduler
        self._element = element
    }

    override func run<O : ObserverType>(_ observer: O, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where O.Element == Element {
        let sink = JustScheduledSink(parent: self, observer: observer, cancel: cancel)
        let subscription = sink.run()
        return (sink: sink, subscription: subscription)
    }
}

final private class Just<Element>: Producer<Element> {
    private let _element: Element
    
    init(element: Element) {
        self._element = element
    }
    
    override func subscribe<O: ObserverType>(_ observer: O) -> Disposable where O.Element == Element {
        observer.on(.next(self._element))
        observer.on(.completed)
        return Disposables.create()
    }
}
