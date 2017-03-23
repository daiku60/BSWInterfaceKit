//
//  Created by Pierluigi Cifani on 06/05/16.
//  Copyright © 2016 Blurred Software SL. All rights reserved.
//

import Foundation

open class ScrollableStackView: UIScrollView {
    
    fileprivate let stackView = UIStackView()
    
    public init(axis: UILayoutConstraintAxis = .vertical,
                alignment: UIStackViewAlignment = .leading) {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.alignment = alignment

        addSubview(stackView)

        stackView.fillSuperview()
        
        switch axis {
        case .horizontal:
            stackView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
            alwaysBounceHorizontal = true
        case .vertical:
            stackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            alwaysBounceVertical = true
        }
        
        clipsToBounds = true
    }

    open func addArrangedSubview(_ subview: UIView, layoutMargins: UIEdgeInsets) {
        stackView.addArrangedSubview(subview, layoutMargins: layoutMargins)
    }
    
    open func addArrangedSubview(_ subview: UIView) {
        stackView.addArrangedSubview(subview)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override class var requiresConstraintBasedLayout : Bool {
        return true
    }
    
    open func viewAtIndex(_ index: Int) -> UIView? {
        return stackView.arrangedSubviews[safe: index]
    }
    
    open func indexOfView(_ view: UIView) -> Int? {
        return stackView.arrangedSubviews.index(of: view)
    }

    open func removeAllArrangedViews() {
        stackView.removeAllArrangedSubviews()
    }
}
