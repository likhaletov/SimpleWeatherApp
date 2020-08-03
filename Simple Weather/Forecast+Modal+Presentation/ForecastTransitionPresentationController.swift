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
        guard let containerView = containerView else { return .zero }
        
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
        return frame
    }
    
    override func containerViewDidLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    
}
