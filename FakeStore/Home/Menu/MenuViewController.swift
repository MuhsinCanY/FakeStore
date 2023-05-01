//
//  MenuViewController.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 17.03.2023.
//

import UIKit
import SnapKit
import RealmSwift

class MenuViewController: UIViewController {
    
    let realm = try! Realm()
    let menuCells = [Menu(imageName: "profile", text: "Profile"),
                     Menu(imageName: "favorite", text: "Favorites"),
                     Menu(imageName: "settings", text: "Settings"),
                     Menu(imageName: "aboutUs", text: "About Us")]
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero)
        tv.register(MenuTableViewCell.self, forCellReuseIdentifier: "menuCell")
        tv.delegate = self
        tv.dataSource = self
        tv.rowHeight = 40
        tv.separatorColor = .clear
        tv.isScrollEnabled = false
        tv.showsVerticalScrollIndicator = false
        tv.backgroundColor = .clear
        return tv
    }()
    
    lazy var userImageView: UIImageView = {
        let iv = UIImageView(frame: .zero)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "user")
        return iv
    }()
    
    lazy var userImagePickerButton = AnimatedButton(backgroundColor: .lightGray, iconImageName: "plus", iconImageColor: .black, action: UIAction.init(handler: { _ in
        print("Tapped")
        self.selectPhotoFromLibrary()
    }))
    
    lazy var userImageRemoveButton = AnimatedButton(backgroundColor: .lightGray, iconImageName: "cancel", iconImageColor: .black, action: UIAction.init(handler: { _ in
        try! self.realm.write {
            self.realm.deleteAll()
            self.userImageView.image = UIImage(named: "user")
        }
    }))
    
    lazy var userName: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 18)
        lbl.textAlignment = .center
        lbl.text = "User Name"
        return lbl
    }()
    
    lazy var logOutButton = AnimatedButton(title: "LOGOUT", titleColor: .systemRed, font: .boldSystemFont(ofSize: 18), backgroundColor: .init(white: 0, alpha: 0.1), cornerRadius: 8, action: UIAction.init(handler: { _ in
        self.navigationController?.popToRootViewController(animated: true)
    }))

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let imageData = realm.objects(Photo.self).first?.imageData{
            self.userImageView.image = UIImage(data: imageData)
        }

    }
    
    func selectPhotoFromLibrary(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    

    override func viewDidLayoutSubviews() {
        
        let seperatorView: UIView = {
            let view = UIView()
            view.backgroundColor = .darkGray
            return view
        }()

        
        view.backgroundColor = .systemBackground
        view.addSubviews(seperatorView, tableView, userImageView, userImagePickerButton, userImageRemoveButton, userName, logOutButton)
        
        seperatorView.snp.makeConstraints { make in
            make.trailing.equalTo(view)
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(83)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(userName.snp_bottomMargin).inset(-30)
            make.trailing.equalTo(seperatorView.snp_leadingMargin).offset(-10)
        }
        
        userImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.centerX.equalTo(tableView)
            make.height.width.equalTo(180)
        }
        userImageView.layer.borderWidth = 1
        userImageView.layer.cornerRadius = 90
        userImageView.layer.borderColor = UIColor.darkGray.cgColor
        
        userImagePickerButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(userImageView).inset(13)
            make.height.width.equalTo(30)
        }
        
        userImagePickerButton.layer.cornerRadius = 15
        
        userImageRemoveButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(userImageView).inset(13)
            make.height.width.equalTo(24)
        }
        
        userImageRemoveButton.layer.cornerRadius = 12
        
        userName.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp_bottomMargin).inset(-15)
            make.centerX.equalTo(userImageView)
        }
        
        logOutButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.trailing.equalTo(seperatorView.snp_leadingMargin).offset(-20)
            make.leading.equalTo(view).offset(20)
            make.height.equalTo(45)
        }

    }
    

}

extension MenuViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            self.userImageView.image = image
            
            if let data = image.jpegData(compressionQuality: 0.5){
                let photo = Photo(imageData: data)
                try! realm.write {
                    realm.deleteAll()
                    realm.add(photo)
                }
            }
        }
        dismiss(animated: true)
    }
    
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableViewCell
        
        let menu = menuCells[indexPath.row]
        cell.configureCell(with: menu)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let name = menuCells[indexPath.row].text
        if name == "Profile"{
            navigationController?.pushViewController(ProfileViewController(), animated: true)
        }else if name == "Favorites"{
            navigationController?.pushViewController(FavoriteViewController(), animated: true)
        }else if name == "Settings"{
            navigationController?.pushViewController(SettingsViewController(), animated: true)
        }else if name == "About Us"{
            navigationController?.pushViewController(AboutUsViewController(), animated: true)
        }

    }
}
