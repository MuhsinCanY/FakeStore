//
//  FavoriteViewController.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 19.03.2023.
//

import UIKit
import SnapKit
import RealmSwift

class FavoriteViewController: MenuCustomViewController {
    
    let realm = try! Realm()
    lazy var favorites: Results<Favorite2> = {
        self.realm.objects(Favorite2.self)
    }(){
        didSet{
            emptyImageView.isHidden = !favorites.isEmpty
            textView.isHidden = !favorites.isEmpty
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.cellId)
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    lazy var emptyImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "empyFavorites")
        return iv
    }()
    
    
    let textView = UITextView.createTextViewWithUpperText("No Favorites Yet", lowerText: "Mark your favorites items and always have them here", upperFont: .boldSystemFont(ofSize: 20))

    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle(title: "Favorites")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshCollectionView()
        let notificationName = Notification.Name("refreshFavoriteCollectionView")
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshCollectionView), name: notificationName, object: nil)
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.addSubviews(collectionView, emptyImageView, textView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.leading.trailing.bottom.equalToSuperview()
        }

        emptyImageView.snp.makeConstraints { make in
            make.width.height.equalTo(256)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }

        textView.snp.makeConstraints { make in
            make.width.equalTo(256)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
            make.top.equalTo(emptyImageView.snp.bottomMargin).offset(20)
        }
    }

}

extension FavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.cellId, for: indexPath) as! FavoriteCollectionViewCell
        
        let productId = favorites[indexPath.row]
        cell.configure(favorite: productId)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.bounds.width - 20, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = favorites[indexPath.item].productId
        
        let sheetViewController = DetailViewController(productId: id)
        sheetViewController.modalPresentationStyle = .formSheet
        sheetViewController.modalTransitionStyle = .coverVertical
        present(sheetViewController, animated: true)
    }
    
    
}

extension FavoriteViewController: FavoriteCollectionViewCellProtocol{
    
    @objc func refreshCollectionView() {
        self.favorites = realm.objects(Favorite2.self)
        collectionView.reloadData()
    }
  
}

