//
//  AnimatedButton.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 15.03.2023.
//

import UIKit

class AnimatedButton: UIButton {
    
    var gradientLayer: CAGradientLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    //Main
    convenience init(title: String? = nil, titleColor: UIColor? = nil, font: UIFont? = nil, backgroundColor: UIColor? = nil, cornerRadius: CGFloat? = nil, image: UIImage? = nil, tintColor: UIColor? = nil, iconImageName: String? = nil, iconImageColor: UIColor? = nil,  action: UIAction? = nil ) {
        self.init(frame: .zero)
        set(title: title, titleColor: titleColor, font: font, backgroundColor: backgroundColor, cornerRadius: cornerRadius, image: image, tintColor: tintColor, iconImageName: iconImageName, iconImageColor: iconImageColor, action: action)
    }
    //TODO: Düzenle
    convenience init(image: UIImage? = nil, action: UIAction? = nil) {
        self.init(frame: .zero)
        set(title: nil, titleColor: nil, font: nil, backgroundColor: nil, cornerRadius: nil, image: image, tintColor: nil, iconImageName: nil, iconImageColor: nil, action: action)
    }

    convenience init(image: UIImage? = nil, backgroundColor: UIColor? = nil, action: UIAction? = nil) {
        self.init(frame: .zero)
        set(title: nil, titleColor: nil, font: nil, backgroundColor: backgroundColor, cornerRadius: nil, image: image, tintColor: nil, iconImageName: nil, iconImageColor: nil, action: action)
    }
    
    private func set(title: String? = nil, titleColor: UIColor? = nil, font: UIFont? = nil, backgroundColor: UIColor? = nil, cornerRadius: CGFloat? = nil, image: UIImage? = nil, tintColor: UIColor? = nil, iconImageName: String? = nil, iconImageColor: UIColor? = nil, action: UIAction? = nil ) {
        if let title = title {
            setTitle(title, for: .normal)
        }
        if let titleColor = titleColor {
            setTitleColor(titleColor, for: .normal)
        }
        if let font = font {
            titleLabel?.font = font
        }
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
        if let tintColor = tintColor {
            self.tintColor = tintColor
        }
        if let cornerRadius = cornerRadius {
            layer.cornerRadius = cornerRadius
        }
        if let image = image {
            setImage(image, for: .normal)
        }
        if let iconImageName = iconImageName, let iconImageColor = iconImageColor {
            setImageWithColor(name: iconImageName, color: iconImageColor)
        }
        if let action = action {
            addAction(action, for: .touchUpInside)
        }
    }
    
    //Animation
    func setupButton() {
        addTarget(self, action: #selector(scaleToSmall), for: .touchDown)
        addTarget(self, action: #selector(scaleToDefault), for: .touchDragExit)
        addTarget(self, action: #selector(scaleAnimation), for: .touchUpInside)
    }
    
    @objc func scaleToSmall() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: nil)
    }
    
    @objc func scaleToDefault() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    @objc func scaleAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.transform = CGAffineTransform(scaleX: 1.18, y: 1.18)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
                self.transform = CGAffineTransform.identity
            }, completion: nil)
        })
    }
    
}
