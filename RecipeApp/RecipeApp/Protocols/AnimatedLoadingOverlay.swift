//
//  AnimatedLoadingOverlay.swift
//  RecipeApp
//
//  Created by Nathan Wale on 31/5/2023.
//

import UIKit

protocol AnimatedLoadingOverlay
{
    var loadingOverlay: UIView! { get }
}


extension AnimatedLoadingOverlay
{
    //
    // start loading animation for general info
    //
    func startLoadingAnimation()
    {
        loadingOverlay.isHidden = false
        for view in loadingOverlay.subviews {
            UIView.animate(
                withDuration: 5.0,
                delay: 0,
                usingSpringWithDamping: 0.6,
                initialSpringVelocity: 0.1,
                options: [.repeat])
            {
                view.transform = view.transform.rotated(by: .pi * 1)
                view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }
        }
    }
    
    
    //
    // stop loading animation for general info
    //
    func stopLoadingAnimation()
    {
        loadingOverlay.isHidden = true
        for view in loadingOverlay.subviews {
            view.layer.removeAllAnimations()
        }
    }
}
