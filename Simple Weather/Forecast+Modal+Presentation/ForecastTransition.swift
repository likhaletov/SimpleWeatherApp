//
//  ForecastTransition.swift
//  Simple Weather
//
//  Created by Dmitry Likhaletov on 27.07.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit

class ForecastTransition: NSObject {
    
}

extension ForecastTransition: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let presentationController = ForecastDimmedTransitionPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
        
        return presentationController
        
    }
    
}
