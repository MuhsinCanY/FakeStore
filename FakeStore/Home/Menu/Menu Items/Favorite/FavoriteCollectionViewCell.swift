//
//  FavoriteCollectionViewCell.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 19.03.2023.
//

import UIKit
import SnapKit
import Cosmos

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    static let cellId = "favoriteCell"
    
    let productImageView = CustomImageView().productImageView()
    
    lazy var productTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    let productPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    lazy var trashButton = AnimatedButton(image: UIImage(named: "trash"), action: UIAction.init(handler: { _ in
        print("trash tapped")
    }))
    
    let ratingView: CosmosView = {
        let view = CosmosView()
        view.settings.updateOnTouch = false
        view.settings.fillMode = .half
        view.settings.starSize = 23
        view.settings.starMargin = 3
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpLayout(){
        
        contentView.addSubviews(productImageView, productTitleLabel, productPriceLabel, trashButton, ratingView)
        
        productImageView.snp.makeConstraints { make in
            make.bottom.top.equalTo(contentView).inset(10)
            make.leading.equalTo(contentView).inset(10)
            make.width.equalTo(100)
        }
        
        
        productTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(productImageView.snp_trailingMargin).inset(-16)
            make.top.equalTo(contentView).inset(10)
            make.trailing.equalTo(contentView).inset(35)
            make.height.equalTo(50)
        }
        
        productPriceLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(contentView).inset(10)
        }
        
        trashButton.snp.makeConstraints { make in
            make.height.width.equalTo(25)
            make.top.equalTo(14)
            make.trailing.equalTo(-10)
        }
        
        ratingView.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).inset(10)
            make.leading.equalTo(productImageView.snp_trailingMargin).inset(-20)
        }
        
        productPriceLabel.text = "$100"
        ratingView.text = "+123123"
        productPriceLabel.backgroundColor = .lightGray
        productImageView.backgroundColor = .lightGray
        productTitleLabel.backgroundColor = .lightGray
    }
    
}
