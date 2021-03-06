//
//  Created by Pierluigi Cifani on 28/04/16.
//  Copyright © 2016 Blurred Software SL. All rights reserved.
//

import UIKit
import Cartography

class AvatarView: UIView {
    
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    fileprivate let size: Size
    
    var photo: Photo {
        didSet {
            updateImage()
        }
    }
    
    // MARK: Initialization
    
    init(size: Size, photo: Photo) {
        self.size = size
        self.photo = photo
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View setup
    
    fileprivate func setup() {
        layer.masksToBounds = true
        addSubview(imageView)
        updateImage()
        setupConstraints()
    }
    
    fileprivate func updateImage() {
        imageView.bsw_setPhoto(photo)
    }
    
    // MARK: Constraints
    
    fileprivate func setupConstraints() {
        self.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        self.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .vertical)
        
        constrain(imageView) { imageView in
            imageView.edges == imageView.superview!.edges
        }
    }
    
    override var intrinsicContentSize : CGSize {
        return CGSize(width: size.rawValue, height: size.rawValue)
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
    
    // MARK: Avatar size
    
    enum Size: CGFloat {
        case smallest = 18
        case small = 25
        case medium = 30
        case big = 40
        case bigger = 44
        case biggest = 60
        case huge = 80
    }
}
