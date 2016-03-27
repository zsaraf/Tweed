//
//  SeshDotView.swift
//  Sesh
//
//  Created by Raymond Kennedy on 12/9/15.
//  Copyright © 2015 Zachary Waleed Saraf. All rights reserved.
//

import Foundation

class SeshDotView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath(ovalInRect: rect)
        UIColor.tweedGray().setFill()
        path.fill()
    }

    static func typicalSize() -> Double {
        return 6.0
    }
}