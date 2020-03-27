//
//  SearchResultTableViewCell.swift
//  StorytelTask
//
//  Created by ChrisTappin on 26/03/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    let cover: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.sizeThatFits(CGSize(width: 64, height: 64))
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let authorsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let narratorsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cover)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorsLabel)
        contentView.addSubview(narratorsLabel)
        
        let marginGuide = contentView.layoutMarginsGuide
        
//        cover.bounds = CGRect(x: contentView.frame.x, y: 0, width: 64, height: 64)
//        productNameLabel.anchor(top: topAnchor, left: productImage.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
//        productDescriptionLabel.anchor(top: productNameLabel.bottomAnchor, left: productImage.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
        
        let coverConstraints = [
            cover.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            cover.topAnchor.constraint(equalTo: marginGuide.topAnchor),
            cover.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor),
            cover.widthAnchor.constraint(equalToConstant: 64),
            cover.heightAnchor.constraint(equalToConstant: 64)
        ]
        NSLayoutConstraint.activate(coverConstraints)
        
        let titleLabelconstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: cover.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor)
        ]
        NSLayoutConstraint.activate(titleLabelconstraints)
        
        let authorsLabelconstraints = [
            authorsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            authorsLabel.leadingAnchor.constraint(equalTo: cover.trailingAnchor, constant: 10),
            authorsLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor)
            
        ]
        NSLayoutConstraint.activate(authorsLabelconstraints)
        
        let narratorsLabelconstraints = [
            narratorsLabel.topAnchor.constraint(equalTo: authorsLabel.bottomAnchor),
            narratorsLabel.leadingAnchor.constraint(equalTo: cover.trailingAnchor, constant: 10),
            narratorsLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            narratorsLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor)
            
        ]
        NSLayoutConstraint.activate(narratorsLabelconstraints)
        
//        let stackView = UIStackView(arrangedSubviews: [titleLabel, authorsLabel, narratorsLabel])
//        stackView.distribution = .equalSpacing
//        stackView.axis = .vertical
//        stackView.spacing = 5
//        addSubview(stackView)
        
//        authorsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
//        authorsLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//
//        let narratorsLabelConstraints = [
//            titleLabel.topAnchor.constraint(equalTo: authorsLabel.bottomAnchor),
//            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
//            titleLabel.widthAnchor.constraint(equalToConstant: frame.size.width)
//        ]
//        NSLayoutConstraint.activate(narratorsLabelConstraints)
//
//        sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
//        <#code#>
//    }

}
