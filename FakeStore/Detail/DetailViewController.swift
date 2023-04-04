//
//  DetailViewController.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 6.03.2023.
//

import UIKit
import SnapKit
import RealmSwift
import Cosmos

class DetailViewController: UIViewController{
    
    let width = (UIScreen.main.bounds.width - 30) / 2
    
    var products: Product?
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
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    let productPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let ratingView: CosmosView = {
        let view = CosmosView()
        view.settings.updateOnTouch = false
        view.settings.fillMode = .half
        view.settings.starSize = 30
        view.settings.starMargin = 3
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    let collectionTitle: UILabel = {
        let label = UILabel()
        label.text = "Other Products"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(HomeMainCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.showsHorizontalScrollIndicator = false
        
        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let notificationName = Notification.Name("refreshFavoriteCollectionView")
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
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
                self.ratingView.text = "(+\(product.rating.count))"
                self.ratingView.rating = product.rating.rate
                self.productPriceLabel.text = "$" + String(format: "%.2f", product.price)
                self.descriptionLabel.text = product.description
                
                let titleHeight = product.title.height(withConstrainedWidth: self.view.bounds.width - 60, font: .systemFont(ofSize: 20, weight: .bold))
                self.titleLabel.snp.makeConstraints { make in
                    make.height.equalTo(titleHeight)
                }
                
                let descriptionHeight = product.description.height(withConstrainedWidth: self.view.bounds.width - 60, font: .systemFont(ofSize: 15, weight: .regular))
                self.descriptionLabel.snp.makeConstraints { make in
                    make.height.equalTo(descriptionHeight + 10)
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GetProduct.shared.getProduct { product in
            if let product = product{
                var randomElements = [ProductElement]()
                while randomElements.count < 5 {
                    if let element = product.randomElement(), !randomElements.contains(where: { $0.id == element.id }) {
                        randomElements.append(element)
                    }
                }
                self.products = randomElements
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Main Views
        let bottomView = UIView()
        bottomView.backgroundColor = .white.withAlphaComponent(0.7)
        
        view.addSubviews(scrollView, bottomView)
        bottomView.addSubview(addCartButton)
        
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        addCartButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(20)
            make.bottom.equalTo(-25)
            make.height.equalTo(40)
        }
        
        bottomView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(view)
            make.height.equalTo(75)
        }
        
        //ScrollView
        scrollView.addSubviews(productImageView, titleLabel, ratingView, productPriceLabel, descriptionLabel, favoriteButton, containerView)
        
        productImageView.snp.makeConstraints { make in
            make.top.equalTo(scrollView).inset(20)
            make.height.width.equalTo(view.bounds.width - 50)
            make.centerX.equalTo(scrollView.snp_centerXWithinMargins)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.trailing.leading.equalTo(view).inset(30)
            make.top.equalTo(productImageView.snp_bottomMargin).inset(-20)
        }
        
        ratingView.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(30)
            make.top.equalTo(titleLabel.snp_bottomMargin).inset(-20)
        }
        
        productPriceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(view).inset(30)
            make.centerY.equalTo(ratingView)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.trailing.leading.equalTo(view).inset(30)
            make.top.equalTo(ratingView.snp_bottomMargin).inset(-10)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalTo(view).inset(15)
            make.top.equalTo(productImageView.snp_topMargin)
            make.width.height.equalTo(30)
        }
        //ContainerView
        containerView.addSubviews(collectionView, collectionTitle)
        
        containerView.snp.makeConstraints { make in
            make.trailing.leading.equalTo(view).inset(30)
            make.top.equalTo(descriptionLabel.snp_bottomMargin).inset(-20)
            make.height.equalTo(width * 1.3 + 60)
        }
        
        collectionTitle.snp.makeConstraints { make in
            make.trailing.leading.top.equalTo(containerView)
            make.height.equalTo(30)
        }
        
        collectionView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalTo(containerView)
            make.top.equalTo(collectionTitle.snp_bottomMargin).offset(10)
        }
        
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        let contentHeight = 70 + 20 + containerView.frame.height + navigationBarHeight + productImageView.frame.height + ratingView.frame.height + titleLabel.frame.height + descriptionLabel.frame.height

        scrollView.contentSize = CGSize(width: view.frame.width, height: contentHeight)
    }
    
    init(productId: Int) {
        self.productId = productId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeMainCollectionViewCell
        let randomProduct = products?[indexPath.item]
        if let randomProduct = randomProduct{
            cell.configure(product: randomProduct)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: width, height: width * 1.3)
    }
    
}
