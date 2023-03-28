//
//  MenuViewController.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 19.03.2023.
//

import UIKit
import SnapKit

class MenuCustomViewController: UIViewController {
    
    lazy var closeButton = AnimatedButton(iconImageName: "angle-left", iconImageColor: UIColor.black, action: UIAction.init(handler: { _ in
        self.navigationController?.popViewController(animated: true)
    }))
    
    let pageTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        return label
    }()

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
        
        view.addSubviews(closeButton, pageTitle)
        closeButton.frame = CGRect(x: 5, y: 50, width: 40, height: 40)
        
        pageTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(closeButton.snp_centerYWithinMargins)
        }
    }
    
    func setTitle(title: String){
        pageTitle.text = title
    }
    
}
