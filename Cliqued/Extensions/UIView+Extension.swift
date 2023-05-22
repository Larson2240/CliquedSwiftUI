//
//  UIView+Extension.swift
//  Bubbles
//
//  Created by C100-107 on 23/04/20.
//  Copyright © 2020 C100-107. All rights reserved.
//

import UIKit
extension UIView {
    func superview<T>(of type: T.Type) -> T? {
        return superview as? T ?? superview.map { $0.superview(of: type)! }
    }
    
    func subview<T>(of type: T.Type) -> T? {
        return subviews.compactMap { $0 as? T ?? $0.subview(of: type) }.first
    }
    class func loadFromNib<T: UIView>() -> T {
        return UINib.init(nibName: String(describing: self), bundle: nil).instantiate(withOwner: self, options: nil).first as! T
    }
    
    func fixInView(_ container: UIView) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.frame
        container.addSubview(self)
        
        NSLayoutConstraint(
            item: self, attribute: .leading, relatedBy: .equal,
            toItem: container, attribute: .leading, multiplier: 1.0, constant: 0)
            .isActive = true
        
        NSLayoutConstraint(
            item: self, attribute: .trailing, relatedBy: .equal,
            toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0)
            .isActive = true
        
        NSLayoutConstraint(
            item: self, attribute: .top, relatedBy: .equal,
            toItem: container, attribute: .top, multiplier: 1.0, constant: 0)
            .isActive = true
        
        NSLayoutConstraint(
            item: self, attribute: .bottom, relatedBy: .equal,
            toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0)
            .isActive = true
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    // story module related
    var igLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.leftAnchor
        }
        return self.leftAnchor
    }
    var igRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.rightAnchor
        }
        return self.rightAnchor
    }
    var igTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        }
        return self.topAnchor
    }
    var igBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        }
        return self.bottomAnchor
    }
    var igCenterXAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.centerXAnchor
        }
        return self.centerXAnchor
    }
    var igCenterYAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.centerYAnchor
        }
        return self.centerYAnchor
    }
    var width: CGFloat {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.layoutFrame.width
        }
        return frame.width
    }
    var height: CGFloat {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.layoutFrame.height
        }
        return frame.height
    }
    
    func addDashedBorder() {
        //Create a CAShapeLayer
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.lineWidth = 2
        // passing an array with the values [2,3] sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment
        shapeLayer.lineDashPattern = [2,3]
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: 0, y: self.frame.size.height)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, radius: CGFloat = 3, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    //MARK: UIView 3D Background
    func viewBackgroundDesign(viewName: UIView, cornerRadius: CGFloat) {
        viewName.layer.cornerRadius = cornerRadius
        viewName.layer.masksToBounds = false
        viewName.layer.shadowColor = UIColor.gray.cgColor
        viewName.layer.shadowRadius = 5.0
        viewName.layer.shadowOpacity = 0.6
        viewName.layer.shadowOffset = CGSize(width: 0 , height: 3)
    }
    
    //MARK: UIView Round Corner
    func viewRoundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        self.layoutIfNeeded()
    }
    
    //MARK: Add Gradient Overley on Imageview
    func addGradientOverleyOnImageview(imageView: UIImageView, gradientHeight: NSNumber) {
        let view = UIView(frame: imageView.frame)
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, gradientHeight]
        view.layer.insertSublayer(gradient, at: 0)
        imageView.addSubview(view)
        imageView.bringSubviewToFront(view)
    }
    
    func addBlurToView() {
        
    }
}
