//
//  UIView+RxTapGesture.swift
//  Feature
//
//  Created by Assistant on 10/3/25.
//

import UIKit
import RxSwift

public extension Reactive where Base: UIView {
    @MainActor
    func tapGesture(configuration: ((UITapGestureRecognizer) -> Void)? = nil) -> Observable<UITapGestureRecognizer> {
        return Observable.create { [weak base] observer in
            guard let view = base else {
                observer.onCompleted()
                return Disposables.create()
            }

            let recognizer = UITapGestureRecognizer()
            configuration?(recognizer)
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(recognizer)

            let target = GestureTarget(recognizer: recognizer) { recognizer in
                observer.onNext(recognizer)
            }

            objc_setAssociatedObject(recognizer, &AssociatedKeys.gestureTargetKey, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            return Disposables.create {
                recognizer.removeTarget(nil, action: nil)
                if view.gestureRecognizers?.contains(recognizer) == true {
                    view.removeGestureRecognizer(recognizer)
                }
                objc_setAssociatedObject(recognizer, &AssociatedKeys.gestureTargetKey, nil, .OBJC_ASSOCIATION_ASSIGN)
            }
        }
    }
}

private enum AssociatedKeys {
    @MainActor
    static var gestureTargetKey: UInt8 = 0
}

@MainActor
private final class GestureTarget: NSObject {
    private let handler: (UITapGestureRecognizer) -> Void

    init(recognizer: UITapGestureRecognizer, handler: @escaping (UITapGestureRecognizer) -> Void) {
        self.handler = handler
        super.init()
        recognizer.addTarget(self, action: #selector(eventHandler(_:)))
    }

    @objc private func eventHandler(_ recognizer: UITapGestureRecognizer) {
        handler(recognizer)
    }
}

