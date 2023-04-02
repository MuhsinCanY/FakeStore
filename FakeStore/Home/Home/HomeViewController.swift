//
//  ViewController.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 3.03.2023.
//

import UIKit
import SnapKit
import RealmSwift

protocol HomeControllerDelegate{
    func handleMenuToggle()
}

class HomeViewController: UIViewController {
    
    var products = Product()
    var categories = [String]()
    var delegate: HomeControllerDelegate?
    lazy var realm = try! Realm()
    lazy var cartProducts: Results<ProductCart> = {
        self.realm.objects(ProductCart.self)
    }()
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(HomeMainCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.showsVerticalScrollIndicator = false
        
        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
    lazy var categoryCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(HomeCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "categotyCell")
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    lazy var searchBar: UISearchBar = {
        let searhBar = UISearchBar()
        searhBar.backgroundImage = UIImage()
        searhBar.searchTextField.textColor = .black
        searhBar.searchTextField.font = .systemFont(ofSize: 18, weight: .regular)
        searhBar.searchTextField.backgroundColor = .clear
        searhBar.searchTextField.leftView = UIImageView(image: UIImage(named: "search")?.withTintColor(UIColor.init(white: 0, alpha: 0.5), renderingMode: .alwaysOriginal))
        searhBar.placeholder = "Search Here"
        
        return searhBar
    }()
    
    lazy var menuButton = AnimatedButton(iconImageName: "menu", iconImageColor: .black, action: UIAction.init(handler: { _ in
        print("menutapped")
        self.delegate?.handleMenuToggle()
    }))
    
    lazy var cartButtonBadge: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .red
        return button
    }()
    
    lazy var cartButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImageWithColor(name: "goCart", color: .white)
        button.backgroundColor = .systemOrange
        button.addAction(UIAction.init(handler: { _ in
            self.navigationController?.pushViewController(CartViewController(), animated: true)
        }), for: .touchUpInside)
        
        return button
    }()
    
    lazy var activityIndicator : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        let count = cartProducts.filter { $0.check == true }.count
        if count > 0{
            cartButtonBadge.setTitle("\(count)", for: .normal)
            cartButtonBadge.isHidden = false
        }else{
            cartButtonBadge.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.hidesSearchBarWhenScrolling = true
        
        view.backgroundColor = .systemBackground
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        
        searchBar.delegate = self
        
        GetCategories.shared.getCategories { json in
            self.categories = json
//            self.categories.insert("All", at: 0)
            DispatchQueue.main.async {
                self.categoryCollectionView.reloadData()
                self.categoryCollectionView.selectItem(at: IndexPath.init(item: 0, section: 0), animated: true, scrollPosition: .centeredVertically)
            }
        }
        
        activityIndicator.startAnimating()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        view.addSubviews(collectionView, categoryCollectionView, menuButton ,searchBar, cartButton, cartButtonBadge , activityIndicator)
        
        collectionView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalTo(view)
            make.top.equalTo(categoryCollectionView.snp_bottomMargin).offset(4)
        }
        
        categoryCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(8)
            make.top.equalTo(searchBar.snp_bottomMargin).offset(12)
            make.height.equalTo(44)
        }
        
        menuButton.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(12)
            make.top.equalTo(view.safeAreaInsets.top)
            make.height.equalTo(44)
            make.width.equalTo(22)
        }
        
        searchBar.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(48)
            make.trailing.equalTo(view).inset(8)
            make.top.equalTo(view.safeAreaInsets.top)
            make.height.equalTo(44)
        }
        
        cartButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.trailing.bottom.equalTo(view).inset(30)
        }
        
        cartButtonBadge.snp.makeConstraints { make in
            make.height.equalTo(26)
            make.leading.equalTo(cartButton.snp_trailingMargin).offset(-5)
            make.top.equalTo(cartButton.snp_topMargin).offset(-8)
        }
        
        cartButtonBadge.layer.cornerRadius = 13
        
        activityIndicator.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.center.equalToSuperview()
        }
        
        cartButton.layer.cornerRadius = cartButton.bounds.width / 2
        
        searchBar.layer.borderWidth = 1.0
        searchBar.layer.borderColor = CGColor(gray: 0, alpha: 0.5)
        searchBar.layer.cornerRadius = 15.0
        
    }
    
    func fetchData(){
        
        GetProduct.shared.getProduct { product in
            if let product = product{
                self.products = product
                self.collectionViewStopAnimating()
            }
        }
    }
    
    
    func collectionViewStartAnimating(){
        self.products.removeAll()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.activityIndicator.startAnimating()
        }
    }
    
    
    func collectionViewStopAnimating(){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
}

// MARK: - CollectionView
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView{
            var category = categories[indexPath.item]
            category = category.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            collectionViewStartAnimating()
            if category == "All"{
                fetchData()
//                collectionViewStopAnimating()
            }else{
                GetProduct.shared.getProduct(withCategory: category) { product in
                    if let product = product{
                        self.products = product
                        self.collectionViewStopAnimating()
                    }
                }
                
            }
            
        }else{
            let id = products[indexPath.item].id
            navigationController?.pushViewController(DetailViewController(productId: id), animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == categoryCollectionView{
            return categories.count
        }else{
            return products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == categoryCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categotyCell", for: indexPath) as! HomeCategoryCollectionViewCell
            cell.label.text = categories[indexPath.item].capitalized
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeMainCollectionViewCell
            let product = products[indexPath.item]
            cell.configure(product: product)
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView{
            let width = categories[indexPath.item].capitalized.widthOfString(usingFont: UIFont.systemFont(ofSize: 15))
            return CGSize(width: width + 25, height: 40)
        }else{
            let width = (UIScreen.main.bounds.width - 30) / 2
            return CGSize(width: width, height: width * 1.3)
        }
    }
    
}

// MARK: - SearchBar
extension HomeViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == ""{
            fetchData()
        }else{
            if searchText.count >= 2{
                collectionViewStartAnimating()
                GetProduct.shared.getProduct { product in
                    var searchProdunct = Product()
                    product?.forEach({ element in
                        if element.title.lowercased().contains(searchText.lowercased()){
                            searchProdunct.append(element)
                        }
                    })
                    self.products = searchProdunct
                    self.collectionViewStopAnimating()
                }
            }
        }
        
    }
    
}

