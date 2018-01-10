//
//  Cancelable.swift
//  RxSwift
//
//  Created by Krunoslav Zaher on 3/12/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

/// Represents disposable resource with state tracking.
public class Cancelable : Disposable {
    /// Was resource disposed.
    var isDisposed: Bool { fatalError() }
}
