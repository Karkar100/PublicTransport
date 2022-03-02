//
//  UINavigationControllerExtension.swift
//  Public Transport
//
//  Created by Diana Princess on 27.02.2022.
//

import UIKit
import BottomSheet

extension UINavigationController {
    private static var transitionKey: UInt8 = 0

    public var multicastingDelegate: MulticastDelegate {
        if let object = objc_getAssociatedObject(self, &Self.transitionKey) as? MulticastDelegate {
            return object
        }

        let object = MulticastDelegate(
            target: self,
            delegateGetter: #selector(getter: delegate),
            delegateSetter: #selector(setter: delegate)
        )
        objc_setAssociatedObject(self, &Self.transitionKey, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return object
    }
}

