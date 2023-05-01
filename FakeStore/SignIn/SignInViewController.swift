//
//  SignInViewController.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 30.04.2023.
//

import UIKit
import SkyFloatingLabelTextField
import SnapKit

class SignInViewController: UIViewController {
    
    lazy var emailTextField: UITextField = {
        let tf = SkyFloatingLabelTextFieldWithIcon(frame: .zero, iconType: .image)
        tf.iconImage = UIImage(systemName: "envelope.fill")
        tf.placeholder = "E-mail"
        tf.title = "E-mail adress"

        tf.iconColor = .lightGray

        tf.selectedTitleColor = .black
        tf.selectedIconColor = .black
        tf.selectedLineColor = .black

        tf.errorColor = .red
        tf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        return tf
    }()
    
    lazy var passwordTextField: UITextField = {
        let tf = SkyFloatingLabelTextFieldWithIcon(frame: .zero, iconType: .image)
        
        let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
        
        tf.iconImage = UIImage(systemName: "key.fill")
        tf.placeholder = "Password"
        tf.title = "Password"

        tf.iconColor = .lightGray
        tf.isSecureTextEntry = true

        tf.tintColor = overcastBlueColor
        tf.selectedTitleColor = overcastBlueColor
        tf.selectedLineColor = overcastBlueColor
        tf.selectedIconColor = overcastBlueColor

        tf.iconRotationDegrees = 90
        
        return tf
    }()
    
    lazy var guestLoginButton = AnimatedButton(title: "Login as guest", titleColor: .black, font: .systemFont(ofSize: 15), backgroundColor: .lightGray, cornerRadius: 8, action: UIAction.init(handler: { _ in
        self.buttonTapped()
    }))

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.addSubviews(emailTextField, passwordTextField, guestLoginButton)
        
        emailTextField.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.height.equalTo(45)
            make.width.equalTo(view.frame.width - 100)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp_bottomMargin).offset(20)
            make.centerX.equalTo(view)
            make.height.equalTo(45)
            make.width.equalTo(view.frame.width - 100)
        }
        
        guestLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp_bottomMargin).offset(-20)
            make.centerX.equalTo(view)
            make.height.equalTo(45)
            make.width.equalTo(200)
        }
    }
    
    @objc func buttonTapped(){
        navigationController?.pushViewController(ContainerViewController(nibName: nil, bundle: nil), animated: true)
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if let text = textfield.text {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                if(text.count < 3 || !text.contains("@")) {
                    floatingLabelTextField.errorMessage = "Invalid email"
                }
                else {
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }

}
