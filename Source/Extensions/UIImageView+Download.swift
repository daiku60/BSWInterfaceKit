//
//  Created by Pierluigi Cifani on 28/04/16.
//  Copyright © 2016 Blurred Software SL. All rights reserved.
//

import PINRemoteImage
import BSWFoundation
import Deferred

public typealias BSWImageCompletionBlock = (TaskResult<UIImage>) -> Void

extension UIImageView {

    private static var webDownloadsEnabled = true

    @objc(bsw_disableWebDownloads)
    static public func disableWebDownloads() {
        webDownloadsEnabled = false
    }

    @objc(bsw_enableWebDownloads)
    static public func enableWebDownloads() {
        webDownloadsEnabled = false
    }

    @objc(bsw_setImageFromURLString:)
    public func setImageFromURLString(_ url: String) {
        if let url = URL(string: url) {
            setImageWithURL(url)
        }
    }

    @objc(bsw_cancelImageLoadFromURL)
    public func cancelImageLoadFromURL() {
        pin_cancelImageDownload()
    }

    @nonobjc
    public func setImageWithURL(_ url: URL, completed completedBlock: BSWImageCompletionBlock? = nil) {
        guard UIImageView.webDownloadsEnabled else { return }
        pin_setImage(from: url) { (downloadResult) in

            let result: TaskResult<UIImage>
            if let image = downloadResult.image {
                result = .success(image)
            } else if let error = downloadResult.error {
                result = .failure(error)
            } else {
                result = .failure(NSError(domain: "com.bswinterfacekit.uiimageview", code: 0, userInfo: nil))
            }
            
            completedBlock?(result)
        }
    }

    @nonobjc
    public func setPhoto(_ photo: Photo) {
        switch photo.kind {
        case .image(let image):
            self.image = image
        case .url(let url):
            backgroundColor = photo.averageColor
            setImageWithURL(url) { result in
                guard result.error == nil else { return }
                self.image = result.value
                self.backgroundColor = nil
            }
        case .empty:
            backgroundColor = photo.averageColor
        }
    }
}

