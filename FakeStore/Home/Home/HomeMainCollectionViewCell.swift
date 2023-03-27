//
//  MainCollectionViewCell.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 3.03.2023.
//

import UIKit
import SnapKit
import Cosmos

class HomeMainCollectionViewCell: UICollectionViewCell {
    

    let productImageView = CustomImageView().productImageView()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    
    let ratingView: CosmosView = {
        let view = CosmosView()
        view.settings.updateOnTouch = false
        view.settings.fillMode = .half
        view.settings.starSize = 17
        view.settings.starMargin = 3
        return view
    }()
    
    
    let addCartButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .black
        button.setImage(UIImage(named: "addCart")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        priceLabel.text = ""
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setUpViews()
        
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.lightGray.cgColor //CGColor(gray: 0, alpha: 0.5)
        contentView.layer.cornerRadius = 15.0
        
        self.layer.cornerRadius = 15
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize(width: -2, height: -2)
        self.clipsToBounds = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(product: ProductElement){
        productImageView.downloadSetImage(url: product.image)
        priceLabel.text = "$" + String(format: "%.2f", product.price)
        ratingView.rating = product.rating.rate
        ratingView.text = "(+\(product.rating.count))"
    }
    
    
    private func setUpViews(){
        contentView.addSubviews(productImageView, priceLabel, ratingView, addCartButton)
        
        productImageView.snp.makeConstraints { make in
            make.trailing.leading.top.equalTo(contentView)
            make.bottom.equalTo(contentView).inset(70)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(20)
            make.bottom.equalTo(contentView).inset(34)
            make.width.equalTo(contentView.bounds.width / 2)
            make.height.equalTo(30)
        }
        
        ratingView.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).inset(10)
            make.leading.equalTo(contentView).inset(20)
        }
        
        addCartButton.snp.makeConstraints { make in
            make.height.width.equalTo(33)
            make.top.equalTo(productImageView.snp_bottomMargin).inset(-13)
            make.trailing.equalTo(contentView).inset(10)
        }
    }
    
    
}
