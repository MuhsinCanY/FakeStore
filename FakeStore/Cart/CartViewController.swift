//
//  CartViewController.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 10.03.2023.
//


import UIKit
import SnapKit

class CartViewController: UIViewController{
    
    var viewModel = CartViewModel()
    
    var cartProducts: [ProductCart] = []{
        didSet{
            emptyImageView.isHidden = !cartProducts.isEmpty
            empytTextView.isHidden = !cartProducts.isEmpty
            totalPriceLabel.isHidden = cartProducts.isEmpty
            totalLabel.isHidden = cartProducts.isEmpty
            checkoutButton.isEnabled = !cartProducts.isEmpty
            checkoutButton.isOpaque = !cartProducts.isEmpty
            checkoutButton.alpha = cartProducts.isEmpty ? 0.5 : 1.0
            collectionView.reloadData()
        }
    }
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(CartCollectionViewCell.self, forCellWithReuseIdentifier: "cartCell")
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    let checkoutView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    lazy var checkoutButton = AnimatedButton(title: "CHECKOUT", titleColor: .white, font: .systemFont(ofSize: 20), backgroundColor: .black, cornerRadius: 5, action: UIAction.init(handler: { _ in
        print("checkoutButton")
    }))
    
    let totalPriceLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .right
        label.font = .boldSystemFont(ofSize: 25)
        label.text = "$0.00"
        return label
    }()
    
    let totalLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.text = "TOTAL :"
        return label
    }()
    
    lazy var emptyImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "emptyCart")
        return iv
    }()
    
    
    let empytTextView = UITextView.createTextViewWithUpperText("Your Cart is Empty", lowerText: "Looks like you haven't added anything to your cart yet")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        
        viewModel.data.bind { [weak self] products in
            self?.cartProducts = products ?? []
        }
        
        viewModel.recievedData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.recievedData()
        updatePrice()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        title = "Cart"
        view.addSubviews(collectionView, checkoutView, emptyImageView, empytTextView)
        checkoutView.addSubviews(checkoutButton, totalLabel, totalPriceLabel)
        
        collectionView.snp.makeConstraints { make in
            make.top.trailing.leading.equalTo(view)
            make.bottom.equalTo(checkoutView.snp_topMargin)
        }
        
        checkoutView.snp.makeConstraints { make in
            make.bottom.trailing.leading.equalTo(view)
            make.height.equalTo(120)
        }
        
        checkoutButton.snp.makeConstraints { make in
            make.trailing.equalTo(-20)
            make.leading.equalTo(20)
            make.bottom.equalTo(-25)
            make.height.equalTo(40)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.bottom.equalTo(checkoutButton.snp_topMargin).offset(-10)
        }
        
        totalPriceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-20)
            make.bottom.equalTo(checkoutButton.snp_topMargin).offset(-10)
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.width.height.equalTo(256)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }

        empytTextView.snp.makeConstraints { make in
            make.width.equalTo(256)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
            make.top.equalTo(emptyImageView.snp.bottomMargin).offset(20)
        }
        
    }
    
}

extension CartViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cartProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cartCell", for: indexPath) as! CartCollectionViewCell
        cell.configure(cartProduct: cartProducts[indexPath.item])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.bounds.width - 20, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = cartProducts[indexPath.item].id
        navigationController?.pushViewController(DetailViewController(productId: id), animated: true)
    }
    
}

extension CartViewController: CartCollectionViewCellProtocol{
    func trashButtonTapped() {
        viewModel.recievedData()
    }
    
    func updatePrice() {
        var price: Double = 0
        cartProducts.forEach { if $0.check == true { price += ($0.price * Double($0.productQuantity)) } }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
            self.totalPriceLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { _ in
            self.totalPriceLabel.text = "$" + String(format: "%.2f", price)
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
                self.totalPriceLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }
        
    }
}
