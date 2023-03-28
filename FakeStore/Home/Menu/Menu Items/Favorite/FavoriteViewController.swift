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
    }()
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.addSubviews(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.bottom.trailing.leading.equalTo(view)
            make.top.equalTo(view).inset(100)
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
        cell.configure(productId: productId.productId)
        
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
        present(sheetViewController, animated: true, completion: nil)
    }
    
    
}
