//
//  Created by Pierluigi Cifani on 03/05/16.
//  Copyright © 2016 Blurred Software SL. All rights reserved.
//

import UIKit
import Deferred
import BSWFoundation

public enum ClassicProfileEditKind {
    case nonEditable
    case editable(UIBarButtonItem)
    
    public var isEditable: Bool {
        switch self {
        case .editable(_):
            return true
        default:
            return false
        }
    }
}

open class ClassicProfileViewController: AsyncViewModelViewController<ClassicProfileViewModel> {

    public let scrollableStackView = ScrollableStackView()

    enum Constants {
        static let SeparatorSize = CGSize(width: 30, height: 1)
        static let LayoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        static let PhotoGalleryRatio = CGFloat(0.78)
    }
    
    open var editKind: ClassicProfileEditKind = .nonEditable
    
    fileprivate let photoGallery = PhotoGalleryView()
    fileprivate let titleLabel = UILabel.unlimitedLinesLabel()
    fileprivate let detailsLabel = UILabel.unlimitedLinesLabel()
    fileprivate let extraDetailsLabel = UILabel.unlimitedLinesLabel()
    fileprivate let separatorView: UIView = {
        let view = UIView()
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: Constants.SeparatorSize.width),
            view.heightAnchor.constraint(equalToConstant: Constants.SeparatorSize.height)
            ])
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    fileprivate var navBarBehaviour: NavBarTransparentBehavior?

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollableStackView)
        view.backgroundColor = UIColor.white
        scrollableStackView.fillSuperview()

        //This is set to false in order to layout the image below the transparent navBar
        automaticallyAdjustsScrollViewInsets = false
        if let tabBar = tabBarController?.tabBar {
            scrollableStackView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tabBar.frame.height, right: 0)
        }
        
        //Add the photoGallery
        photoGallery.delegate = self
        scrollableStackView.addArrangedSubview(photoGallery)

        NSLayoutConstraint.activate([
            photoGallery.heightAnchor.constraint(equalTo: photoGallery.widthAnchor, multiplier: Constants.PhotoGalleryRatio),
            photoGallery.widthAnchor.constraint(equalTo: scrollableStackView.widthAnchor)
            ])
        
        scrollableStackView.addArrangedSubview(titleLabel, layoutMargins: Constants.LayoutMargins)
        scrollableStackView.addArrangedSubview(detailsLabel, layoutMargins: Constants.LayoutMargins)
        scrollableStackView.addArrangedSubview(separatorView, layoutMargins: Constants.LayoutMargins)
        scrollableStackView.addArrangedSubview(extraDetailsLabel, layoutMargins: Constants.LayoutMargins)
        
        //Add the rightBarButtonItem
        switch editKind {
        case .editable(let barButton):
            navigationItem.rightBarButtonItem = barButton
        default:
            break
        }
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //This is the transparent navBar behaviour
        if let navBar = self.navigationController?.navigationBar {
            navBarBehaviour = NavBarTransparentBehavior(navBar: navBar, scrollView: scrollableStackView)
        }
        
        //Add the rightBarButtonItem
        switch editKind {
        case .editable(let barButton):
            navigationItem.rightBarButtonItem = barButton
        default:
            break
        }

    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navBarBehaviour?.setNavBar(toState: .regular)
    }
    
    override open var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Private
    
    open override func configureFor(viewModel: ClassicProfileViewModel) {
        photoGallery.photos = viewModel.photos
        titleLabel.attributedText = viewModel.titleInfo
        detailsLabel.attributedText = viewModel.detailsInfo
        extraDetailsLabel.attributedText = viewModel.extraInfo.joinedStrings()
    }
}

//MARK:- PhotoGalleryViewDelegate

extension ClassicProfileViewController: PhotoGalleryViewDelegate {
    public func didTapPhotoAt(index: UInt, fromView: UIView) {
        
        guard let viewModel = dataProvider.peek()?.value else { return }
        
        let gallery = PhotoGalleryViewController(
            photos: viewModel.photos,
            presentFromView: fromView,
            initialPageIndex: index,
            allowShare: false
        )
        gallery.delegate = self
        present(gallery, animated: true, completion: nil)
    }
}

//MARK:- PhotoGalleryViewControllerDelegate

extension ClassicProfileViewController: PhotoGalleryViewControllerDelegate {
    public func photoGalleryController(_ photoGalleryController: PhotoGalleryViewController, willDismissAtPageIndex index: UInt) {
        photoGallery.scrollToPhoto(atIndex: index)
        dismiss(animated: true, completion: nil)
    }
}
