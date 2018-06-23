//
//  DrawView.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 23/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import Foundation

import UIKit

public class DrawView: UIView {
    
    var lines: [Line] = []
    var lastPoint: CGPoint!
    var drawColor = UIColor.black
    var drawWidth = 3
    var bgColor = UIColor.yellow
    var canPaint = true
    var image = UIImage()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = bgColor
    }

    public func clear() {
        self.lines = []
    }
    public func getLines() -> [Line] {
        return self.lines
    }
    public func changeBgColorTo(_ color:UIColor) {
        self.backgroundColor = color
    }
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with:event)
        if (canPaint) {
            lastPoint = touches.first?.location(in: self)
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with:event)
        if (canPaint) {
            let newPoint = touches.first?.location(in: self)
            lines.append(Line(start: lastPoint, end: newPoint!, color: drawColor, width:Float(drawWidth)))
            lastPoint = newPoint
            self.setNeedsDisplay()
        }
    }
    
    public override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineCap(CGLineCap.round)
        context?.setStrokeColor(drawColor.cgColor)
        context!.setLineWidth(CGFloat(drawWidth))
        for line in lines {
            context!.beginPath()
            context?.move(to: line.start)
            context?.addLine(to: line.end)
            context?.strokePath()
        }
    }
    
    public func getImage() -> UIImage {
        UIGraphicsBeginImageContext(self.frame.size);
        
        let context = UIGraphicsGetCurrentContext()
        
        let rect = CGRect(x:0, y:0, width: self.frame.size.width, height: self.frame.size.height)
        context?.setFillColor(bgColor.cgColor)
        context?.fill(rect)
        context?.setLineCap(CGLineCap.round)
        
        context?.setStrokeColor(drawColor.cgColor)
        context!.setLineWidth(CGFloat(drawWidth))
        for line in lines {
            context!.beginPath()
            context?.move(to: line.start)
            context?.addLine(to: line.end)
            context?.strokePath()
        }
        self.image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return self.image
    }
}

