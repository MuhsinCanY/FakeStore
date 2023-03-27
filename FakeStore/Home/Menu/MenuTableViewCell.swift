//
//  MenuTableViewCell.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 18.03.2023.
//

import UIKit

class MenuTableViewCell: UITableViewCell{
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectedBackgroundView  = UIView(frame: .zero)
        
        addSubviews(iconImageView, descriptionLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalTo(12)
            make.centerY.equalTo(contentView)
            make.height.width.equalTo(36)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp_trailingMargin).offset(12)
            make.centerY.equalTo(contentView)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with menu: Menu){
        imageView?.image = UIImage(named: "\(menu.imageName)")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        textLabel?.text = "\(menu.text)"
    }
    
    
}

