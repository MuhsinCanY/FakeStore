//
//  MenuViewController.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 19.03.2023.
//

import UIKit

class MenuCustomViewController: UIViewController {
    
    lazy var closeButton = AnimatedButton(iconImageName: "angle-left", iconImageColor: UIColor.black, action: UIAction.init(handler: { _ in
        self.navigationController?.popViewController(animated: true)
    }))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.addSubviews(closeButton)
        closeButton.frame = CGRect(x: 5, y: 50, width: 40, height: 40)
    }

}
