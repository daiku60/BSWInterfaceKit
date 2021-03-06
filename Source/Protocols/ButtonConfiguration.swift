//
//  Created by Pierluigi Cifani on 17/05/16.
//  Copyright © 2016 Blurred Software SL. All rights reserved.
//

import Foundation
import ObjectiveC

public typealias ButtonActionHandler = (Void) -> Void

public struct ButtonConfiguration {
    public let title: NSAttributedString
    public let backgroundColor: UIColor
    public let contentInset: UIEdgeInsets
    public let actionHandler: ButtonActionHandler

    public init(title: String,
                titleColor: UIColor = .black,
                backgroundColor: UIColor = .blue,
                contentInset: UIEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5),
                actionHandler: @escaping ButtonActionHandler) {
        self.title = TextStyler.styler.attributedString(title, color: titleColor)
        self.backgroundColor = backgroundColor
        self.actionHandler = actionHandler
        self.contentInset = contentInset
    }

    public init(title: NSAttributedString,
                backgroundColor: UIColor = UIColor.blue,
                contentInset: UIEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5),
                actionHandler: @escaping ButtonActionHandler) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.actionHandler = actionHandler
        self.contentInset = contentInset
    }
}

private class ActionBlockWrapper : NSObject {
    var block : ButtonActionHandler
    init(block: @escaping ButtonActionHandler) {
        self.block = block
    }
}

extension UIButton {
    
    fileprivate struct AssociatedObjects {
        static var ActionBlockWrapper = "ActionBlockWrapper"
    }
    
    public convenience init(buttonConfiguration: ButtonConfiguration) {
        self.init()
        setButtonConfiguration(buttonConfiguration)
    }
    
    public func setButtonConfiguration(_ buttonConfiguration: ButtonConfiguration) {
        setAttributedTitle(buttonConfiguration.title, for: UIControlState())
        backgroundColor = buttonConfiguration.backgroundColor
        contentEdgeInsets = buttonConfiguration.contentInset
        objc_setAssociatedObject(self, &AssociatedObjects.ActionBlockWrapper, ActionBlockWrapper(block: buttonConfiguration.actionHandler), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        addTarget(self, action: #selector(handleTap), for: .touchDown)
    }
    
    func handleTap() {
        guard let wrapper = objc_getAssociatedObject(self, &AssociatedObjects.ActionBlockWrapper) as? ActionBlockWrapper else { return }
        wrapper.block()
    }
}

extension UIBarButtonItem {

    fileprivate struct AssociatedObjects {
        static var ActionBlockWrapper = "ActionBlockWrapper"
    }

    public convenience init(barButtonSystemItem systemItem: UIBarButtonSystemItem, actionHandler: @escaping ButtonActionHandler) {
        self.init(barButtonSystemItem:systemItem, target:nil, action: #selector(handleTap))
        objc_setAssociatedObject(self, &AssociatedObjects.ActionBlockWrapper, ActionBlockWrapper(block: actionHandler), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        self.target = self
        self.action = #selector(handleTap)
    }
    
    func handleTap() {
        guard let wrapper = objc_getAssociatedObject(self, &AssociatedObjects.ActionBlockWrapper) as? ActionBlockWrapper else { return }
        wrapper.block()
    }
}
