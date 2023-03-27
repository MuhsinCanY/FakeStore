//
//  ContainerViewController.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 17.03.2023.
//

import UIKit

class ContainerViewController: UIViewController {
        
    
    // MARK: - Properties
    
    var menuController: UIViewController!
    var centerController: UIViewController!
    var isExtended = false
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Handlers
    
//    override var preferredStatusBarStyle: UIStatusBarStyle{
//        .lightContent
//    }
    
    func configureHomeViewController(){
        let homeController = HomeViewController()
        homeController.delegate = self
        centerController = UINavigationController(rootViewController: homeController)
        
        addChild(centerController)
        centerController.view.frame = view.frame
        view.addSubview(centerController.view)
        centerController.didMove(toParent: self)
    }
    
    func configureMenuViewController(){
        if menuController == nil{
            menuController = MenuViewController()
            addChild(menuController)
            view.insertSubview(menuController.view, at: 0)
            menuController.didMove(toParent: self)
        }
    }
    
    func showMenuController(shouldExtend: Bool){
        
        if shouldExtend {
            //show menu
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 80
            } completion: { completed in

            }
        }else{
            //hide menu
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
                self.centerController.view.frame.origin.x = 0
            } completion: { completed in

            }
        }
    }
}

extension ContainerViewController: HomeControllerDelegate{
    func handleMenuToggle() {
        if !isExtended{
            configureMenuViewController()
        }
        
        isExtended.toggle()
        showMenuController(shouldExtend: isExtended)
    }
}
