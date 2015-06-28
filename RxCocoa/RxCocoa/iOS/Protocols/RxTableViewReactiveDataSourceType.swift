//
//  RxTableViewReactiveDataSourceType.swift
//  RxCocoa
//
//  Created by Krunoslav Zaher on 6/26/15.
//  Copyright (c) 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

// Please take a look at `DelegateBridgeType.swift`
public protocol RxTableViewReactiveDataSourceType : RxTableViewDataSourceType {
    typealias Element
    
    func tableView(tableView: UITableView, observedEvent: Event<Element>) -> Void
}