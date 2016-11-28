//
//  MTCoordinateManager.swift
//
//  Created by mittsuu on 2016/09/12.
//
//

import UIKit

open class MTCoordinateManager: UIView {
    
    fileprivate var headerView: UIView?
    fileprivate var containerViews: Array<MTCoordinateContainer>!
    
    fileprivate var parentViewHeight = 0.f
    fileprivate var statusNaviHeight = 0.f

    fileprivate var headerViewHeight = 0.f
    fileprivate var headerViewWidth = 0.f
    fileprivate var newOriginY = 0.f
    
    // MARK: - init
    
    public convenience init(vc: UIViewController, scrollView: UIScrollView) {
        self.init(vc: vc, scrollView: scrollView, header: nil)
    }
    
    public convenience init(vc: UIViewController, scrollView: UIScrollView, header: UIView?) {
        self.init(frame:CGRect.zero)
        initialize(vc, sv: scrollView, hv: header)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initialize(_ vc: UIViewController, sv: UIScrollView, hv: UIView?) {
        
        let status = UIApplication.shared.statusBarFrame.height
        let navigation = vc.navigationController?.navigationBar.frame.height ?? 0
        statusNaviHeight = status + navigation
        
        parentViewHeight = vc.view.frame.height

        if let header = hv {
            headerView = header
            headerViewHeight = header.frame.height
            headerViewWidth = header.frame.width
            newOriginY = header.frame.origin.y - headerViewHeight
            headerView!.frame = CGRect(x: header.frame.origin.x, y: newOriginY, width: headerViewWidth, height: headerViewHeight)
            
            sv.contentInset = UIEdgeInsetsMake(headerView!.frame.height, 0, 0, 0)
            sv.addSubview(header)
        } else {
            headerViewHeight = 0
            headerViewWidth = 0
            newOriginY = 0
        }
        
        containerViews = []
    }

    
    // MARK: - set container
    
    open func setContainer(_ scroll: UIScrollView, views: MTCoordinateContainer...) {
        containerViews = views
        
        for (_, view) in containerViews.enumerated() {
            view.setHeader(statusNaviHeight, transitionHeight: headerViewHeight)
            scroll.addSubview(view)
        }
    }
    
    
    // MARK: - scroll event
    
    open func scrolledDetection(_ scrollView: UIScrollView) {
        let overScroll = scrollView.bounds.origin.y + scrollView.contentInset.top
        if overScroll < 0 {
            self.belowDrawing(overScroll)
        } else if overScroll > 0 {
            self.aboveDrawing(overScroll)
        } else {
            self.resetDraw()
        }
    }
    
    fileprivate func belowDrawing(_ overScroll: CGFloat) {
        if let header = headerView {
            header.frame = CGRect(x: overScroll / 2, y: newOriginY + overScroll,
                                      width: headerViewWidth - overScroll, height: headerViewHeight - overScroll)
        }
        
        let ratio = 1 + fabs(overScroll / (parentViewHeight + overScroll))

        for (_, view) in containerViews.enumerated() {
            view.scrolledToBelow(ratio, scroll: overScroll)
        }
    }

    fileprivate func aboveDrawing(_ overScroll: CGFloat) {
        for (_, view) in containerViews.enumerated() {
            let diffX = max(view.startForm.origin.x, view.endForm.origin.x) - min(view.startForm.origin.x, view.endForm.origin.x)
            let diffY = max(view.startForm.origin.y, view.endForm.origin.y) - min(view.startForm.origin.y, view.endForm.origin.y)
            
            var ratioX = 1 - Float(overScroll / diffX)
            if ratioX == -Float.infinity {
                ratioX = 1
            }
            var ratioY = 1 - Float(overScroll / diffY)
            if ratioY == -Float.infinity {
                ratioY = 1
            }
            
            var ratio = min(ratioX, ratioY)
            if ratioX == 1 && ratioY == 1 {
                let maxW = max(view.startForm.size.width, view.endForm.size.width)
                let maxH = max(view.startForm.size.height, view.endForm.size.height)
                ratio = 1 - fabs(Float(overScroll / maxW) * Float(overScroll / maxH))

            }

            if max(diffX, diffY) != 0 && overScroll >= max(diffX, diffY) {
                ratio = 0
            }
            
            view.scrolledToAbove(ratio.f, scroll: overScroll)
        }
    }
    
    fileprivate func resetDraw() {
        if let header = headerView {
            header.frame = CGRect(x: 0, y: newOriginY, width: headerViewWidth, height: headerViewHeight)
        }
        for (_, view) in containerViews.enumerated() {
            view.scrollReset()
        }
    }

}
