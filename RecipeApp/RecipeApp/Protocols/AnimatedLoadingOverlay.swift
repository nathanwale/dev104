//
//  AnimatedLoadingOverlay.swift
//  RecipeApp
//
//  Created by Nathan Wale on 31/5/2023.
//

import UIKit

//
// AnimatedLoadingOverlay
// ...generalises having an overlaying loading image with a spinning image
// ...all subviews in the overlay will spin
//
protocol AnimatedLoadingOverlay
{
    // the view containing the loading image/s
    var loadingOverlay: UIView! { get }
}


//
// Implementation of animation
//
extension AnimatedLoadingOverlay
{
    //
    // start loading animation
    //
    func startLoadingAnimation()
    {
        // show overlay
        loadingOverlay.isHidden = false
        
        // animate ALL sub views
        // automatically repeats
        for view in loadingOverlay.subviews {
            UIView.animate(
                withDuration: 5.0,
                delay: 0,
                usingSpringWithDamping: 0.6,
                initialSpringVelocity: 0.1,
                options: [.repeat])
            {
                // rotate half circle (full circle simplifies to NO ROTATION)
                view.transform = view.transform.rotated(by: .pi * 1)
                // scale in
                view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }
        }
    }
    
    
    //
    // stop loading animation
    //
    func stopLoadingAnimation()
    {
        // hide loading overlay
        loadingOverlay.isHidden = true
        
        // remove animation from all subviews
        for view in loadingOverlay.subviews {
            view.layer.removeAllAnimations()
        }
    }
}
