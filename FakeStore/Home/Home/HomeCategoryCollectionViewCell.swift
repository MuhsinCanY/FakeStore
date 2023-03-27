//
//  HomeCategoryCollectionViewCell.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 6.03.2023.
//

import UIKit
import SnapKit

class HomeCategoryCollectionViewCell: UICollectionViewCell{
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    override var isSelected: Bool{
        didSet{
            self.contentView.backgroundColor = isSelected ? .black : .white
            self.label.textColor = isSelected ? .white : .black 
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(contentView.center)
        }
        
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = CGColor(gray: 0, alpha: 1)
        contentView.layer.cornerRadius = 15.0
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.snp.updateConstraints { make in
            make.center.equalTo(contentView.center)
        }
    }
    
}
