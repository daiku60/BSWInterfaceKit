//
//  Created by Pierluigi Cifani on 16/08/16.
//  Copyright © 2016 Blurred Software SL. All rights reserved.
//

import UIKit

public extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    public static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}

extension UIWindow {
    public func showErrorMessage(_ message: String, error: Error) {
        guard let rootViewController = self.visibleViewController else { return }
        rootViewController.showErrorMessage(message, error: error)
    }
}
