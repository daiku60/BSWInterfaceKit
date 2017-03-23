//
//  Created by Pierluigi Cifani on 2/22/16.
//  Copyright © 2016 Blurred Software SL SL. All rights reserved.
//

import BSWFoundation

extension UIView {

    @objc(bsw_addAutolayoutSubview:)
    public func addAutolayoutSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
    }

    @objc(bsw_findSubviewWithTag:)
    public func findSubviewWithTag(_ tag: NSInteger) -> UIView? {
        return subviews.find(predicate: { return $0.tag == tag} )
    }

    @objc(bsw_removeSubviewWithTag:)
    public func removeSubviewWithTag(_ tag: NSInteger) {
        findSubviewWithTag(tag)?.removeFromSuperview()
    }

    @objc(bsw_removeAllConstraints)
    public func removeAllConstraints() {
        let previousConstraints = constraints
        NSLayoutConstraint.deactivate(previousConstraints)
        removeConstraints(previousConstraints)
    }

    @objc(bsw_roundCorners:)
    public func roundCorners(radius: CGFloat = 10) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }

    @objc(bsw_getColorFromPoint:)
    public func getColorFromPoint(_ point: CGPoint) -> UIColor {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue).rawValue
        
        var pixelData: [UInt8] = [0, 0, 0, 0]
        
        let context = CGContext(data: &pixelData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo)
        context?.translateBy(x: -point.x, y: -point.y);
        self.layer.render(in: context!)
        
        let red = CGFloat(pixelData[0]) / CGFloat(255.0)
        let green = CGFloat(pixelData[1]) / CGFloat(255.0)
        let blue = CGFloat(pixelData[2]) / CGFloat(255.0)
        let alpha = CGFloat(pixelData[3]) / CGFloat(255.0)
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }

    @objc(bsw_fillSuperviewWithEdges:)
    public func fillSuperview(withEdges edges: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: edges.left),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -edges.right),
            topAnchor.constraint(equalTo: superView.topAnchor, constant: edges.top),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -edges.bottom)
            ])
    }

    @objc(bsw_fillSuperviewWithMargin:)
    public func fillSuperview(withMargin margin: CGFloat) {
        let inset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        fillSuperview(withEdges: inset)
    }

    @objc(bsw_centerInSuperview)
    public func centerInSuperview() {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superView.centerXAnchor),
            centerYAnchor.constraint(equalTo: superView.centerYAnchor)
            ])
    }

    @nonobjc
    public class func instantiateFromNib<T: UIView>(_ viewType: T.Type) -> T? {
        let className = NSStringFromClass(viewType).components(separatedBy: ".").last!
        let bundle = Bundle(for: self)
        return bundle.loadNibNamed(className, owner: nil, options: nil)?.first as? T
    }

    @objc(bsw_instantiateFromNib)
    public class func instantiateFromNib() -> Self? {
        return instantiateFromNib(self)
    }
}
