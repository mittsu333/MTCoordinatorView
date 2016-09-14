//
//  MTCoordinateContainer.swift
//
//  Created by mittsuu on 2016/09/12.
//
//

import UIKit

public class MTCoordinateContainer: UIView, UIGestureRecognizerDelegate {
    
    public enum SmoothMode: Int {
        case NONE = 0
        case FIXITY = 1
    }
    
    private var contentsView: UIView!
    
    private var topPadding = 0.f
    private var cornerRadius = 0.f
    private var scrollDifference = 0.f
    
    private var smoothMode: SmoothMode?
    private var tapGesture: UITapGestureRecognizer!
    private var complete = { () -> Void in }
    
    var startForm: CGRect = CGRectZero
    var endForm: CGRect = CGRectZero
    
    // MARK: - init
    
    public convenience init(view: UIView, endForm: CGRect, completion:() -> Void) {
        self.init(view: view, endForm: endForm, corner: 0.0, mode: .NONE, completion: completion)
    }

    public convenience init(view: UIView, endForm: CGRect, corner: Float, completion:() -> Void) {
        self.init(view: view, endForm: endForm, corner: corner, mode: .NONE, completion: completion)
    }

    public convenience init(view: UIView, endForm: CGRect, mode: SmoothMode, completion:() -> Void) {
        self.init(view: view, endForm: endForm, corner: 0.0, mode: mode, completion: completion)
    }
    
    public convenience init(view: UIView, endForm: CGRect, corner: Float, mode: SmoothMode, completion:() -> Void) {
        self.init(frame:view.frame)
        initialize(view, end: endForm, corner: corner, mode: mode, completion: completion)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize(view: UIView, end: CGRect, corner: Float, mode: SmoothMode, completion:() -> Void) {
        
        smoothMode = mode
        
        startForm = view.frame
        endForm = end
        if corner > 0 && corner <= 1 {
            cornerRadius = corner.f;
        }
        contentsView = view

        self.frame = startForm
        contentsView.frame = CGRectMake(0, 0, startForm.width, startForm.height)
        self.addSubview(contentsView)
        
        tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapEvent))
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
        
        complete = completion
    }
    
    // MARK: - set header view

    func setHeader(systemHeight: CGFloat, transitionHeight: CGFloat) {
        topPadding = systemHeight
        startForm = CGRectOffset(startForm, 0, -transitionHeight)
        endForm = CGRectOffset(endForm, 0, -transitionHeight)
        if startForm.origin.y > endForm.origin.y {
            endForm = CGRectOffset(endForm, 0, -systemHeight)
        }
        self.frame = startForm
        contentsView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
    }

    // MARK: - scroll event
    
    func scrollReset() {
        self.frame = startForm
        contentsView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.updateRadiusSize(startForm.width, height: startForm.size.height)
    }
    
    func scrolledToAbove(ratio: CGFloat, scroll: CGFloat) {
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
        
        self.frame = CGRectMake(newX, newY, newWidth, newHeight)
        contentsView.frame = CGRectMake(0, 0, newWidth, newHeight)
        
        self.updateRadiusSize(newWidth, height: newHeight)
        self.applySmoothMode(revRatio, scroll: scroll)
    }
    
    func scrolledToBelow(ratio: CGFloat, scroll: CGFloat) {
        let newWidth = startForm.size.width * fabs(ratio)
        let newHeight = startForm.size.height * fabs(ratio)
        let newY = startForm.origin.y * fabs(ratio)
        let smoothX = (startForm.width - newWidth) / 2
        
        self.frame = CGRectMake(startForm.origin.x, newY, newWidth, newHeight)
        contentsView.frame = CGRectMake(smoothX, 0, newWidth, newHeight)
        
        self.updateRadiusSize(newWidth, height: newHeight)
    }
    
    
    // MARK: - update radius size
    
    private func updateRadiusSize(width: CGFloat, height: CGFloat) {
        if cornerRadius > 0 {
            let newRadius = max(width, height) * cornerRadius
            self.layer.cornerRadius = newRadius
            contentsView.layer.cornerRadius = newRadius
        }
    }
    
    
    // MARK: - smooth option
    
    private func applySmoothMode(ratio: CGFloat, scroll: CGFloat) {
        if smoothMode != .FIXITY {
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
