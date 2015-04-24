//
//  ToastSoldier.swift
//  ToastSoldier
//
//  Created by Brian Hnat on 4/23/15.
//  Copyright (c) 2015 Tryon Solutions. All rights reserved.
//

import UIKit

var ToastActivityView: UnsafePointer<UIView>    =   nil

let ToastPositionDefault  =   "bottom"
let ToastPositionTop      =   "top"
let ToastPositionCenter   =   "center"

let ToastHorizontalMargin : CGFloat  =   10.0
let ToastVerticalMargin   : CGFloat  =   10.0

let ToastActivityWidth:  CGFloat  = 100.0
let ToastActivityHeight: CGFloat  = 100.0
let ToastOpacity:        CGFloat  = 0.8
let ToastCornerRadius:   CGFloat  = 10.0

// shadow appearance
let ToastShadowOpacity  : CGFloat   = 0.8
let ToastShadowRadius   : CGFloat   = 6.0
let ToastShadowOffset   : CGSize    = CGSizeMake(CGFloat(4.0), CGFloat(4.0))

let ToastFadeDuration = 0.2
let ToastDisplayShadow =   true


func centerPointForPosition(position: AnyObject, toast: UIView, inView: UIView) -> CGPoint {
    
    if position is String {
        var toastSize = toast.bounds.size
        var viewSize  = inView.bounds.size
        
        switch position.lowercaseString {
        case ToastPositionTop:
            return CGPointMake(viewSize.width/2, toastSize.height/2 + ToastVerticalMargin)
        case ToastPositionCenter:
            return CGPointMake(viewSize.width/2, viewSize.height/2)
        default:
            return CGPointMake(viewSize.width/2, viewSize.height - toastSize.height/2 - ToastVerticalMargin)
        }
    } else if position is NSValue {
        return position.CGPointValue()
    }
    
    println("Warning: Invalid position for toast.")
    return centerPointForPosition(ToastPositionDefault, toast, inView)
}

public extension UIView {
    
    func makeToast(position pos: AnyObject = "center", message msg: String = "") {
        var existToast = objc_getAssociatedObject(self, &ToastActivityView) as! UIView?
        //        if existToast != nil {
        //            if let timer = objc_getAssociatedObject(existToast, &ToastTimer) as? NSTimer {
        //                timer.invalidate();
        //                self.hideToast(toast: existToast!, force: false);
        //            }
        //        }
        
        if let existingActivityView: UIView? = objc_getAssociatedObject(self, &ToastActivityView) as? UIView {
            
            var activityView = UIView(frame: CGRectMake(0, 0, ToastActivityWidth, ToastActivityHeight))
            activityView.center = centerPointForPosition(pos, activityView, self)
            activityView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(ToastOpacity)
            activityView.alpha = 0.0
            activityView.autoresizingMask = (.FlexibleLeftMargin | .FlexibleTopMargin | .FlexibleRightMargin | .FlexibleBottomMargin)
            activityView.layer.cornerRadius = ToastCornerRadius
            
            if ToastDisplayShadow {
                activityView.layer.shadowColor = UIColor.blackColor().CGColor
                activityView.layer.shadowOpacity = Float(ToastShadowOpacity)
                activityView.layer.shadowRadius = ToastShadowRadius
                activityView.layer.shadowOffset = ToastShadowOffset
            }
            
            var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
            activityIndicatorView.center = CGPointMake(activityView.bounds.size.width / 2, activityView.bounds.size.height / 2)
            activityView.addSubview(activityIndicatorView)
            activityIndicatorView.startAnimating()
            
            if (!msg.isEmpty){
                activityIndicatorView.frame.origin.y -= 10
                var activityMessageLabel = UILabel(frame: CGRectMake(activityView.bounds.origin.x, (activityIndicatorView.frame.origin.y + activityIndicatorView.frame.size.height + 10), activityView.bounds.size.width, 20))
                activityMessageLabel.textColor = UIColor.whiteColor()
                activityMessageLabel.font = (count(msg)<=10) ? UIFont(name:activityMessageLabel.font.fontName, size: 16) : UIFont(name:activityMessageLabel.font.fontName, size: 13)
                activityMessageLabel.textAlignment = .Center
                activityMessageLabel.text = msg
                activityView.addSubview(activityMessageLabel)
            }
            
            let dimmingView = UIView(frame: self.frame)
            dimmingView.backgroundColor = UIColor.clearColor()
            dimmingView.addSubview(activityView)
            self.addSubview(dimmingView)
            
            // self.addSubview(activityView)
            
            // associate activity view with self
            //objc_setAssociatedObject(self, &ToastActivityView, activityView, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            objc_setAssociatedObject(self, &ToastActivityView, dimmingView, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            
            UIView.animateWithDuration(ToastFadeDuration,
                delay: 0.0,
                options: UIViewAnimationOptions.CurveEaseOut,
                animations: {
                    activityView.alpha = 1.0
                },
                completion: nil)
        }
    }
    
    func hideToast() {
        // todo:  see replacement for objc_getAssociatedObject
        var existingActivityView = objc_getAssociatedObject(self, &ToastActivityView) as! UIView?
        if let toast = existingActivityView {
            UIView.animateWithDuration(ToastFadeDuration,
                delay:0.0,
                options:.CurveEaseIn | .BeginFromCurrentState,
                animations: { () -> Void in
                    toast.alpha = 0.0;
                },
                completion: { (Bool) -> Void in
                    toast.removeFromSuperview()
                    objc_setAssociatedObject(self, &ToastActivityView, nil, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            })
        }
    }
}
