//
//  BottomSheetModalDismissalHandler.swift
//  Public Transport
//
//  Created by Diana Princess on 27.02.2022.

import Foundation
public protocol BottomSheetModalDismissalHandler {
    var canBeDismissed: Bool { get }

    func performDismissal(animated: Bool)
}
