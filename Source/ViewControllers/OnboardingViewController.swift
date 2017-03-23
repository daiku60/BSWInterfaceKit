//
//  Created by Pierluigi Cifani on 23/04/16.
//  Copyright © 2016 Blurred Software SL. All rights reserved.
//

import UIKit
import Cartography

open class LaunchScreenViewController: UIViewController {
    
    open var controllerToPresentOnAppereance: UIViewController?
    open var showSpinner = false
    
    open override func loadView() {
        //Folks, don't do this at home!
        let baseVC = UIStoryboard(name: "LaunchScreen", bundle: Bundle.main).instantiateInitialViewController()!
        let view = baseVC.view
        baseVC.view = nil
        self.view = view
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        if showSpinner {
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            view.addSubview(spinner)
            spinner.startAnimating()
            spinner.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                spinner.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
                ])
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let controllerToPresentOnAppereance = controllerToPresentOnAppereance else { return }
        present(controllerToPresentOnAppereance, animated: true, completion: nil)
        self.controllerToPresentOnAppereance = nil
    }
    
    open override var prefersStatusBarHidden : Bool {
        return true
    }
}

class OnboardingViewController: UIViewController {

    weak var onboardingObserver: OnboardingObserver!
    var onboardingCustomization: OnboardingCustomization!
    static let Spacing: CGFloat = 10
    let contentView = UIView()
    
    let socialStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = OnboardingViewController.Spacing
        return stackView
    }()

    let logoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = OnboardingViewController.Spacing
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        contentView.fillSuperview()
        
        //First, the background
        switch onboardingCustomization.background {
        case .color(let color):
            view.backgroundColor = color
        case .image(let image):
            let imageView = UIImageView(image: image)
            contentView.addSubview(imageView)
            imageView.fillSuperview()
        }
        
        //Then, the stackViews
        contentView.addSubview(logoStackView)
        contentView.addSubview(socialStackView)
        constrain(logoStackView, socialStackView) { logoStackView, socialStackView in
            logoStackView.topMargin == logoStackView.superview!.topMargin
            logoStackView.leadingMargin == logoStackView.superview!.leadingMargin
            logoStackView.trailingMargin == logoStackView.superview!.trailingMargin
            socialStackView.bottomMargin == socialStackView.superview!.bottomMargin
            socialStackView.leadingMargin == socialStackView.superview!.leadingMargin
            socialStackView.trailingMargin == socialStackView.superview!.trailingMargin
        }
        
        prepareLogoStackView()
        prepareSocialStackView()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        prepareMarginsForCurrentTraitCollection()
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return onboardingCustomization.statusBarStyle
    }
    
    //MARK:- IBAction
    
    @objc func onLoginFacebook() {
        onboardingObserver.onFacebookAuthenticationRequested()
    }

    //MARK:- Private

    fileprivate func prepareMarginsForCurrentTraitCollection() {
        switch self.traitCollection.verticalSizeClass {
        case .regular:
            contentView.layoutMargins = UIEdgeInsetsMake(40, 8, 8, 8)
        case .compact:
            contentView.layoutMargins = UIEdgeInsetsMake(8, 8, 8, 8)
        case .unspecified:
            contentView.layoutMargins = UIEdgeInsetsMake(8, 8, 8, 8)
        }
    }
    
    fileprivate func prepareSocialStackView() {
        
        let privacyLabel: UILabel = {
            let label = UILabel()
            label.text = "We will never post in your wall"
            label.textAlignment = .center
            label.numberOfLines = 0
            return label
        }()
        
        socialStackView.addArrangedSubview(privacyLabel)
        
        let facebookButton: UIButton = {
            let button = LoginButton(
                title: "Login with Facebook",
                target: self,
                selector: #selector(onLoginFacebook),
                color: UIColor.blue
            )
            return button
        }()
        
        socialStackView.addArrangedSubview(facebookButton)
    }
    
    fileprivate func prepareLogoStackView() {
        
        let logoView: UIImageView = {
            let imageView = UIImageView(image: onboardingCustomization.appLogo)
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        logoStackView.addArrangedSubview(logoView)
        
        let sloganLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.attributedText = onboardingCustomization.appSlogan
            return label
        }()
        
        logoStackView.addArrangedSubview(sloganLabel)
    }
}
