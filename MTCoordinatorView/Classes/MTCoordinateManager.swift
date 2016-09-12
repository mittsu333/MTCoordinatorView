//
//  MTCoordinateManager.swift
//
//  Created by mittsuu on 2016/09/12.
//
//

import UIKit

class MTCoordinateManager: UIView {
    
    // MARK: - init
    
    convenience init(vc: UIViewController, scrollView: UIScrollView) {
        self.init(vc: vc, scrollView: scrollView, header: nil)
    }
    
    convenience init(vc: UIViewController, scrollView: UIScrollView, header: UIView?) {
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
    }

}
