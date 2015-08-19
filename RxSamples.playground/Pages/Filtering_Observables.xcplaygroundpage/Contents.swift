//: [<< Previous](@previous) - [Index](Index)

import RxSwift

/*:
## Filtering Observables

Operators that selectively emit items from a source Observable.



### `where` / `filter`

Emit only those items from an Observable that pass a predicate test
![](filter.png)
[More info in reactive.io website]( http://reactivex.io/documentation/operators/filter.html )
*/

example("filter") {
    let onlyEvensSubscriber = sequence(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
        .filter {
            $0 % 2 == 0
        }
        .subscribeNext { value in
            print("\(value)")
        }
}


/*:
### `distinctUntilChanged`

Suppress duplicate items emitted by an Observable
![](distinct.png)
[More info in reactive.io website]( http://reactivex.io/documentation/operators/distinct.html )
*/
example("distinctUntilChanged") {
    let distinctUntilChangedSubscriber = sequence(1, 2, 3, 1, 1, 4)
        .distinctUntilChanged()
        .subscribeNext { value in
            print("\(value)")
        }
}


/*:
### `take`

Emit only the first n items emitted by an Observable
![](take.png)
[More info in reactive.io website]( http://reactivex.io/documentation/operators/take.html )
*/
example("take") {
    let distinctUntilChangedSubscriber = sequence(1, 2, 3, 4, 5, 6)
        .take(3)
        .subscribeNext { value in
            print("\(value)")
        }
}



//: [Index](Index) - [Next >>](@next)
