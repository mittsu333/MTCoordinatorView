//
//  MTCoordinateManager.swift
//
//  Created by mittsuu on 2016/09/12.
//
//

import UIKit

public class MTCoordinateManager: UIView {
    
    private var headerView: UIView?
    private var containerViews: Array<MTCoordinateContainer>!
    
    private var parentViewHeight = 0.f
    private var statusNaviHeight = 0.f

    private var headerViewHeight = 0.f
    private var headerViewWidth = 0.f
    private var newOriginY = 0.f
    
    // MARK: - init
    
    public convenience init(vc: UIViewController, scrollView: UIScrollView) {
        self.init(vc: vc, scrollView: scrollView, header: nil)
    }
    
    public convenience init(vc: UIViewController, scrollView: UIScrollView, header: UIView?) {
        self.init(frame:CGRectZero)
        initialize(vc, sv: scrollView, hv: header)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize(vc: UIViewController, sv: UIScrollView, hv: UIView?) {
        
        let status = UIApplication.sharedApplication().statusBarFrame.height
        let navigation = vc.navigationController?.navigationBar.frame.height ?? 0
        statusNaviHeight = status + navigation
        
        parentViewHeight = vc.view.frame.height

        if let header = hv {
            headerView = header
            headerViewHeight = header.frame.height
            headerViewWidth = header.frame.width
            newOriginY = header.frame.origin.y - headerViewHeight
            headerView!.frame = CGRectMake(header.frame.origin.x, newOriginY, headerViewWidth, headerViewHeight)
            
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
    
    public func setContainer(scroll: UIScrollView, views: MTCoordinateContainer...) {
        containerViews = views
        
        for (_, view) in containerViews.enumerate() {
            view.setHeader(statusNaviHeight, transitionHeight: headerViewHeight)
            scroll.addSubview(view)
        }
    }
    
    
    // MARK: - scroll event
    
    public func scrolledDetection(scrollView: UIScrollView) {
        let overScroll = scrollView.bounds.origin.y + scrollView.contentInset.top
        if overScroll < 0 {
            self.belowDrawing(overScroll)
        } else if overScroll > 0 {
            self.aboveDrawing(overScroll)
        } else {
            self.resetDraw()
        }
    }
    
    private func belowDrawing(overScroll: CGFloat) {
        if let header = headerView {
            header.frame = CGRectMake(overScroll / 2, newOriginY + overScroll,
                                      headerViewWidth - overScroll, headerViewHeight - overScroll)
        }
        
        let ratio = 1 + fabs(overScroll / (parentViewHeight + overScroll))

        for (_, view) in containerViews.enumerate() {
            view.scrolledToBelow(ratio, scroll: overScroll)
        }
    }

    private func aboveDrawing(overScroll: CGFloat) {
        for (_, view) in containerViews.enumerate() {
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
    
    private func resetDraw() {
        if let header = headerView {
            header.frame = CGRectMake(0, newOriginY, headerViewWidth, headerViewHeight)
        }
        for (_, view) in containerViews.enumerate() {
            view.scrollReset()
        }
    }

}
