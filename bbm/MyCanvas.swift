//
//  MyCanvas.swift
//  bbm
//
//  Created by songgc on 16/8/8.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class MyCanvas: UIView {

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
        
        let bezierPath = UIBezierPath()
        
//        
//        //创建一个矩形，它的所有边都内缩5%
//        let drawingRect = CGRectInset(self.bounds,
//                                      self.bounds.size.width * 0.05,
//                                      self.bounds.size.height * 0.05)
//        
//        //确定组成绘画的点
//        let topLeft = CGPointMake(CGRectGetMinX(drawingRect),
//                                  CGRectGetMinY(drawingRect))
//        
//        let topRight = CGPointMake(CGRectGetMaxX(drawingRect),
//                                   CGRectGetMinY(drawingRect))
//        
//        let bottomRight = CGPointMake(CGRectGetMaxX(drawingRect),
//                                      CGRectGetMaxY(drawingRect))
//        
//        let bottomLeft = CGPointMake(CGRectGetMinX(drawingRect),
//                                     CGRectGetMaxY(drawingRect))
//        
//        let center = CGPointMake(CGRectGetMidX(drawingRect),
//                                 CGRectGetMidY(drawingRect))
//        
//        //开始绘制
//        bezierPath.moveToPoint(topLeft)
//        bezierPath.addLineToPoint(topRight)
//        bezierPath.addLineToPoint(bottomLeft)
//        bezierPath.addCurveToPoint(bottomRight, controlPoint1: center, controlPoint2: center)
//        
//        //使路径闭合，结束绘制
//        bezierPath.closePath()
//        
//        //设定颜色，并绘制它们
//        UIColor.greenColor().setFill()
//        UIColor.blackColor().setStroke()
//        
//        bezierPath.fill()
//        bezierPath.stroke()
    }

}
