//
//  BorderUIView.swift
//  bbm
//
//  Created by songgc on 16/8/18.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class BorderUIView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //把背景色设为透明
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let pathRect = CGRectInset(self.bounds, 1, 1)
        let path = UIBezierPath(roundedRect: pathRect, cornerRadius: 10)
        path.lineWidth = 1
        //UIColor.greenColor().setFill()
        UIColor.lightGrayColor().setStroke()
        path.fill()
        path.stroke()
    }

}
