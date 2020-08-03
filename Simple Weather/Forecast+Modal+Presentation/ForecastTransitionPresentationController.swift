//
//  ForecastTransitionPresentationController.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 27.07.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit

class ForecastTransitionPresentationController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView,
        let presentedView = presentedView else { return .zero }
        
//        let safeBounds = containerView.bounds.inset(by: containerView.safeAreaInsets)
//        let inset: CGFloat = 11
//
//        let targetWidth = safeBounds.width - inset * 2
//        let targetSize = CGSize(
//            width: targetWidth,
//            height: UIView.layoutFittingExpandedSize.height
//        )
//        let targetHeight = presentedView.systemLayoutSizeFitting(
//            targetSize,
//            withHorizontalFittingPriority: .required,
//            verticalFittingPriority: .defaultLow
//        ).height
        
        var frame: CGRect = .zero
        let inset: CGFloat = 30.0
        let bounds = containerView.bounds
        let width = bounds.width - inset
        let height = bounds.height
        
        
        frame = CGRect(
            x: inset / 2,
            y: (bounds.height / 2) - inset / 2,
            width: width,
            height: height / 2
        )
//        var frame = safeBounds
//        frame.origin.x += inset
//        frame.origin.y = frame.size.height - targetHeight - inset
//        frame.size.width = targetWidth
//        frame.size.height = targetHeight
        return frame
    }
    
    override func containerViewDidLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    
}
