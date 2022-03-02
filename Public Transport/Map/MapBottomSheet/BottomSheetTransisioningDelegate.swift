//
//  BottomSheetTransisioningDelegate.swift
//  Public Transport
//
//  Created by Diana Princess on 27.02.2022.
//

import Foundation
import UIKit

public protocol BottomSheetPresentationControllerFactory {
    func makeBottomSheetPresentationController(
        presentedViewController: UIViewController,
        presentingViewController: UIViewController?
    ) -> BottomSheetPresentationController
}

public final class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    // MARK: - Private properties

    private weak var presentationController: BottomSheetPresentationController?
    private let presentationControllerFactory: BottomSheetPresentationControllerFactory
    
    // MARK: - Init

    public init(presentationControllerFactory: BottomSheetPresentationControllerFactory) {
        self.presentationControllerFactory = presentationControllerFactory
    }
    
    // MARK: - UIViewControllerTransitioningDelegate

    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        _presentationController(forPresented: presented, presenting: presenting, source: source)
    }

    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationController
    }

    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        presentationController?.interactiveTransition
    }


    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        presentationController?.interactiveTransition
    }

    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        _presentationController(forPresented: presented, presenting: presenting, source: source)
    }
    
    // MARK: - Private methods
    
    private func _presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> BottomSheetPresentationController {
        if let presentationController = presentationController {
            return presentationController
        }

        let controller = presentationControllerFactory.makeBottomSheetPresentationController(
            presentedViewController: presented,
            presentingViewController: presenting
        )

        presentationController = controller

        return controller
    }
}
