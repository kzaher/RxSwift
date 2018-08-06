//
//  NSTextView+RxTests.swift
//  Tests
//
//  Created by Cee on 8/5/18.
//  Copyright © 2018 Krunoslav Zaher. All rights reserved.
//

import RxSwift
import RxCocoa
import AppKit
import XCTest

final class NSTextViewTests: RxTest {

}

extension NSTextViewTests {
    func testTextView_StringCompletesOnDealloc() {
        let createView: () -> NSTextView = { NSTextView(frame: CGRect(x: 0, y: 0, width: 1, height: 1)) }
        ensurePropertyDeallocated(createView, "a") { (view: NSTextView) in view.rx.string.orEmpty }
    }

    func testTextView_TextDidChange_ForwardsToDelegates() {

        var completed = false

        autoreleasepool {
            let textView = NSTextView()
            let delegate = TextViewDelegate()
            textView.delegate = delegate
            var rxDidChange = false

            _ = textView.rx.string
                .skip(1) // Initial value
                .subscribe(onNext: { _ in
                    rxDidChange = true
                }, onCompleted: {
                    completed = true
                })

            XCTAssertFalse(rxDidChange)
            XCTAssertFalse(delegate.didChange)

            let notification = Notification(
                name: NSText.didChangeNotification,
                object: textView,
                userInfo: ["NSTextView" : NSText()])
            textView.delegate?.textDidChange?(notification)

            XCTAssertTrue(rxDidChange)
            XCTAssertTrue(delegate.didChange)
        }

        XCTAssertTrue(completed)
    }

}

fileprivate final class TextViewDelegate: NSObject, NSTextViewDelegate {

    var didChange = false

    func textDidChange(_ notification: Notification) {
        didChange = true
    }

}
