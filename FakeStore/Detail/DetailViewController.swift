//
//  DetailViewController.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 6.03.2023.
//

import UIKit
import SnapKit
import RealmSwift

class Favorite2: Object{
    @objc dynamic var productId = -1
    
    convenience init(productId: Int) {
        self.init()
        self.productId = productId
    }
}

class DetailViewController: UIViewController{
    
    var productId: Int
    var product: ProductElement?
    let realm = try! Realm()
    var heartButtonImage = UIImage(named: "heartEmpty")
    lazy var favorites: Results<Favorite2> = {
        self.realm.objects(Favorite2.self)
    }()
    
    let productImageView = CustomImageView().productImageView()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .darkGray
        return label
    }()
    
    lazy var addCartButton = AnimatedButton(title: "Add Cart", titleColor: .systemBackground, font: .systemFont(ofSize: 18), backgroundColor: .black, cornerRadius: 5, image: nil, tintColor: nil, iconImageName: nil, iconImageColor: nil, action: .init(handler: { _ in
        self.addCartTapped()
    }))
    
    lazy var favoriteButton = AnimatedButton(image: heartButtonImage, action: .init(handler: { button in
        self.favoriteTapped()
    }))
    
    @objc func favoriteTapped(){
        if favoriteButton.imageView?.image == UIImage(named: "heartEmpty"){
            favoriteButton.setImage(UIImage(named: "heartFill"), for: .normal)
            
            try! realm.write {
                realm.add(Favorite2(productId: self.productId))
            }
            
        }else{
            favoriteButton.setImage(UIImage(named: "heartEmpty"), for: .normal)
            
            let favor = favorites.filter { $0.productId == self.productId }
            try! realm.write {
                realm.delete(favor.first!)
            }
            
        }
    }
    
    @objc func addCartTapped(){
        let cartProduct = ProductCart(id: product!.id, productQuantity: 1, title: product!.title, price: product!.price, image: product!.image, rate: product!.rating.rate, count: product!.rating.count, check: true)
        try! realm.write({
            realm.add(cartProduct)
        })
        navigationController?.pushViewController(CartViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
        
        print(favorites.count)
        for favorite in favorites{
            if favorite.productId == productId{
                self.heartButtonImage = UIImage(named: "heartFill")!
                break
            }
        }
        
          
        GetSingleProduct.shared.getSingleProduct(id: productId) { product in
            if let product = product {
                self.product = product
                
                self.productImageView.downloadSetImage(url: product.image)
                self.titleLabel.text = product.title
                self.descriptionLabel.text = product.description
                
                let titleHeight = product.title.height(withConstrainedWidth: self.view.bounds.width - 60, font: .systemFont(ofSize: 20, weight: .bold))
                self.titleLabel.snp.makeConstraints { make in
                    make.height.equalTo(titleHeight)
                }
                print(titleHeight)
                print(product.title)
                
                let descriptionHeight = product.description.height(withConstrainedWidth: self.view.bounds.width - 60, font: .systemFont(ofSize: 15, weight: .regular))
                self.descriptionLabel.snp.makeConstraints { make in
                    make.height.equalTo(descriptionHeight + 10)
                }
            }
        }
        
    }
    
    
    
    @objc func callMethod(){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.addSubviews(productImageView, titleLabel, descriptionLabel, addCartButton, favoriteButton)
        
        productImageView.snp.makeConstraints { make in
            make.top.equalTo(view).inset(85)
            make.height.width.equalTo(view.bounds.width - 50)
            make.centerX.equalTo(view.snp_centerXWithinMargins)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.trailing.leading.equalTo(view).inset(30)
            make.top.equalTo(productImageView.snp_bottomMargin).inset(-20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.trailing.leading.equalTo(view).inset(30)
            make.top.equalTo(titleLabel.snp_bottomMargin).inset(-10)
        }
        
        addCartButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(20)
            make.bottom.equalTo(-25)
            make.height.equalTo(40)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalTo(view).inset(15)
            make.top.equalTo(85)
            make.width.height.equalTo(30)
        }
        
    }
    
    init(productId: Int) {
        self.productId = productId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
