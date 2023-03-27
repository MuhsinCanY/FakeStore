//
//  CartCollectionViewCell.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 13.03.2023.
//

import UIKit
import RealmSwift

protocol CartCollectionViewCellProtocol{
    func trashButtonTapped()
    func updatePrice()
}

class CartCollectionViewCell: UICollectionViewCell {
    
    let realm = try! Realm()
//    lazy var cartProducts: Results<ProductCart> = {
//        self.realm.objects(ProductCart.self)
//    }()
    var productCount = 0
    var delegate: CartCollectionViewCellProtocol?
    var cartProduct: ProductCart = ProductCart() {
        didSet{
            productCount = cartProduct.productQuantity
            productImageView.downloadSetImage(url: cartProduct.image)
            productTitleLabel.text = cartProduct.title
            let price = Double(productCount) * cartProduct.price
            productPriceLabel.text = "$" + String(format: "%.2f", price)
            productCountLabel.text = "\(cartProduct.productQuantity)"
            if productCount == 1{
                minusButton.backgroundColor = .clear
            }
            if cartProduct.check == true{
                checkButton.checkBoxFill()
            }else{
                checkButton.checkBoxEmpty()
            }
        }
    }
    
    let productImageView = CustomImageView().productImageView()
    
    lazy var checkButton = AnimatedButton(image: UIImage(named: "checkBoxFill"), action: UIAction.init(handler: { _ in
        self.checkTapped()
        self.delegate?.updatePrice()
    }))
    
    lazy var productTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    let countView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var productCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = "\(productCount)"
        return label
    }()

    lazy var plusButton = AnimatedButton(image: UIImage(named: "plus"), backgroundColor: .lightGray, action: UIAction.init(handler: { [weak self] _ in
        self?.plusTapped()
        self?.delegate?.updatePrice()
    }))
    
    lazy var minusButton = AnimatedButton(image: UIImage(named: "minus"), backgroundColor: .lightGray, action: UIAction.init(handler: { _ in
        self.minusTapped()
        self.delegate?.updatePrice()
    }))
    
    let productPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    lazy var trashButton = AnimatedButton(image: UIImage(named: "trash"), action: UIAction.init(handler: { _ in
        try! self.realm.write {
            self.realm.delete(self.cartProduct)
            self.delegate?.trashButtonTapped()
            self.delegate?.updatePrice()
        }
    }))
    

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpLayout()
        
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = CGColor(gray: 0, alpha: 0.5)
        contentView.layer.cornerRadius = 15.0
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func checkTapped(){
        
        if cartProduct.check == true{
            try! realm.write({
                cartProduct.check = false
                checkButton.checkBoxEmpty()
            })
        }else{
            try! realm.write({
                cartProduct.check = true
                checkButton.checkBoxFill()
            })
        }
        
    }
    
    @objc func plusTapped(){
        minusButton.backgroundColor = .lightGray
        productCount += 1
        productCountLabel.text = "\(productCount)"
        let price = Double(productCount) * cartProduct.price
        productPriceLabel.text = "$" + String(format: "%.2f", price)
        try! realm.write({
            cartProduct.productQuantity = productCount
        })
    }
    
    @objc func minusTapped(){
        if productCount != 1 {
            minusButton.backgroundColor = .lightGray
            productCount += -1
            productCountLabel.text = "\(productCount)"
            let price = Double(productCount) * cartProduct.price
            productPriceLabel.text = "$" + String(format: "%.2f", price)
            try! realm.write({
                cartProduct.productQuantity = productCount
            })
        }
        if productCount == 1{
            minusButton.backgroundColor = .clear
        }
    }
    
    func configure(cartProduct: ProductCart){
        self.cartProduct = cartProduct
    }
    
    override func prepareForReuse() {
        productImageView.image = nil
    }
    
    private func setUpLayout(){
        contentView.addSubviews(productImageView, checkButton, productTitleLabel, countView, productPriceLabel, trashButton)
        
        countView.addSubviews(plusButton, minusButton, productCountLabel)
        let minusPlusRadius: CGFloat = 15
        
        minusButton.snp.makeConstraints { make in
            make.centerY.equalTo(countView)
            make.leading.equalTo(5)
            make.width.height.equalTo(minusPlusRadius * 2)
        }
        
        plusButton.snp.makeConstraints { make in
            make.centerY.equalTo(countView)
            make.trailing.equalTo(-5)
            make.width.height.equalTo(minusPlusRadius * 2)
        }
        
        productCountLabel.snp.makeConstraints { make in
            make.center.equalTo(countView)
            make.height.equalTo(30)
            make.width.equalTo(24)
        }
        
        plusButton.layer.cornerRadius = minusPlusRadius
        minusButton.layer.cornerRadius = minusPlusRadius

        productImageView.snp.makeConstraints { make in
            make.bottom.top.equalTo(contentView).inset(10)
            make.leading.equalTo(checkButton.snp_trailingMargin).inset(-16)
            make.width.equalTo(100)
        }
        
        checkButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).inset(14)
            make.height.width.equalTo(22)
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
        
        countView.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).inset(10)
            make.leading.equalTo(productImageView.snp_trailingMargin).inset(-10)
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
        countView.layer.cornerRadius = 20
        
        trashButton.snp.makeConstraints { make in
            make.height.width.equalTo(25)
            make.top.equalTo(14)
            make.trailing.equalTo(-10)
        }
        
    }
    
}

