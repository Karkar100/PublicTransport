//
//  UIEdgesExtension.swift
//  Public Transport
//
//  Created by Diana Princess on 27.02.2022.
//

import UIKit

public extension UIEdgeInsets {
    // MARK: - Public properties

    @inlinable
    var horizontalInsets: CGFloat {
        left + right
    }

    @inlinable
    var verticalInsets: CGFloat {
        top + bottom
    }
}

