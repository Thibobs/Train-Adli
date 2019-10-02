//
//  ProfileViewController.swift
//  Training-Adli
//
//  Created by Adli Raihan on 02/10/19.
//  Copyright (c) 2019 Adli Raihan. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ProfileDisplayLogic: class
{
    func displayToProfile(viewModel : Profile.privateProfile.viewModel)
}

class ProfileViewController: UIViewController, ProfileDisplayLogic
{
    // Outlets
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var usernameProfile: UILabel!
    @IBOutlet weak var followersCountProfile: UILabel!
    @IBOutlet weak var collectionsCountProfile: UILabel!
    
    var interactor: ProfileBusinessLogic?
    var router: (NSObjectProtocol & ProfileRoutingLogic & ProfileDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter()
        let router = ProfileRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        do_getProfile()
    }
    
    private func do_getProfile() {
        interactor?.getProfile()
    }
    
    func displayToProfile(viewModel: Profile.privateProfile.viewModel) {
        self.collectionsCountProfile.text = "\(viewModel.collection ?? 0)"
        self.followersCountProfile.text = "\(viewModel.followers ?? 0)"
        self.usernameProfile.text = "@\(viewModel.username ?? "...." )"
        self.imageProfile.kf.setImage(with: URL.init(string: viewModel.imageURL ?? ""))
    }
    
    // MARK: Do something
    
}

