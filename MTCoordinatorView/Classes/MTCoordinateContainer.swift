//
//  MTCoordinateContainer.swift
//
//  Created by mittsuu on 2016/09/12.
//
//

import UIKit

open class MTCoordinateContainer: UIView, UIGestureRecognizerDelegate {
    
    public enum SmoothMode: Int {
        case none = 0
        case fixity = 1
    }
    
    fileprivate var contentsView: UIView!
    
    fileprivate var topPadding = 0.f
    fileprivate var cornerRadius = 0.f
    fileprivate var scrollDifference = 0.f
    
    fileprivate var smoothMode: SmoothMode?
    fileprivate var tapGesture: UITapGestureRecognizer!
    fileprivate var complete = { () -> Void in }
    
    var startForm: CGRect = CGRect.zero
    var endForm: CGRect = CGRect.zero
    
    // MARK: - init
    
    public convenience init(view: UIView, endForm: CGRect, completion:@escaping () -> Void) {
        self.init(view: view, endForm: endForm, corner: 0.0, mode: .none, completion: completion)
    }

    public convenience init(view: UIView, endForm: CGRect, corner: Float, completion:@escaping () -> Void) {
        self.init(view: view, endForm: endForm, corner: corner, mode: .none, completion: completion)
    }

    public convenience init(view: UIView, endForm: CGRect, mode: SmoothMode, completion:@escaping () -> Void) {
        self.init(view: view, endForm: endForm, corner: 0.0, mode: mode, completion: completion)
    }
    
    public convenience init(view: UIView, endForm: CGRect, corner: Float, mode: SmoothMode, completion:@escaping () -> Void) {
        self.init(frame:view.frame)
        initialize(view, end: endForm, corner: corner, mode: mode, completion: completion)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initialize(_ view: UIView, end: CGRect, corner: Float, mode: SmoothMode, completion:@escaping () -> Void) {
        
        smoothMode = mode
        
        startForm = view.frame
        endForm = end
        if corner > 0 && corner <= 1 {
            cornerRadius = corner.f;
        }
        contentsView = view

        self.frame = startForm
        contentsView.frame = CGRect(x: 0, y: 0, width: startForm.width, height: startForm.height)
        self.addSubview(contentsView)
        
        tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapEvent))
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
        
        complete = completion
    }
    
    // MARK: - set header view

    func setHeader(_ systemHeight: CGFloat, transitionHeight: CGFloat) {
        topPadding = systemHeight
        startForm = startForm.offsetBy(dx: 0, dy: -transitionHeight)
        endForm = endForm.offsetBy(dx: 0, dy: -transitionHeight)
        if startForm.origin.y > endForm.origin.y {
            endForm = endForm.offsetBy(dx: 0, dy: -systemHeight)
        }
        self.frame = startForm
        contentsView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }

    // MARK: - scroll event
    
    func scrollReset() {
        self.frame = startForm
        contentsView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.updateRadiusSize(startForm.width, height: startForm.size.height)
    }
    
    func scrolledToAbove(_ ratio: CGFloat, scroll: CGFloat) {
        let revRatio = ratio < 0 || ratio > 1 ? 0 : ratio
        var newX = endForm.origin.x + ((startForm.origin.x - endForm.origin.x) * revRatio)
        var newY = endForm.origin.y + ((startForm.origin.y - endForm.origin.y) * revRatio)
        let newWidth = endForm.width + ((startForm.width - endForm.width) * revRatio)
        let newHeight = endForm.height + ((startForm.height - endForm.height) * revRatio)
        
        if revRatio == 0 && scrollDifference != 0 {
            let padding = startForm.origin.y != endForm.origin.y ? topPadding : 0
            newY += padding + scroll - scrollDifference
        } else if startForm.origin.y < endForm.origin.y {
            newY += scroll
        } else if (newY - topPadding) < endForm.origin.y {
            newY = self.frame.origin.y
        }
        
        if newWidth < endForm.size.width {
            newX += (endForm.width - newWidth) / 2
        }
        
        self.frame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
        contentsView.frame = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
        
        self.updateRadiusSize(newWidth, height: newHeight)
        self.applySmoothMode(revRatio, scroll: scroll)
    }
    
    func scrolledToBelow(_ ratio: CGFloat, scroll: CGFloat) {
        let newWidth = startForm.size.width * fabs(ratio)
        let newHeight = startForm.size.height * fabs(ratio)
        let newY = startForm.origin.y * fabs(ratio)
        let smoothX = (startForm.width - newWidth) / 2
        
        self.frame = CGRect(x: startForm.origin.x, y: newY, width: newWidth, height: newHeight)
        contentsView.frame = CGRect(x: smoothX, y: 0, width: newWidth, height: newHeight)
        
        self.updateRadiusSize(newWidth, height: newHeight)
    }
    
    
    // MARK: - update radius size
    
    fileprivate func updateRadiusSize(_ width: CGFloat, height: CGFloat) {
        if cornerRadius > 0 {
            let newRadius = max(width, height) * cornerRadius
            self.layer.cornerRadius = newRadius
            contentsView.layer.cornerRadius = newRadius
        }
    }
    
    
    // MARK: - smooth option
    
    fileprivate func applySmoothMode(_ ratio: CGFloat, scroll: CGFloat) {
        if smoothMode != .fixity {
            return
        }

        if ratio == 0 && scrollDifference == 0 {
                scrollDifference = scroll
        } else if ratio != 0 && scrollDifference != 0 {
                scrollDifference = 0
        }
    }
    
    
    // MARK: - tap gesture event
    
    func tapEvent() {
        complete()
    }
    
}
