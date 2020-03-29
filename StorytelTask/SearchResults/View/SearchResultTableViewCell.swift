//
//  SearchResultTableViewCell.swift
//  StorytelTask
//
//  Created by ChrisTappin on 26/03/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import UIKit

/**
 Default properties of a UILabel
 */
@propertyWrapper
struct LabelDefault {
    public var wrappedValue: UILabel {
        didSet {
            wrappedValue.font = .systemFont(ofSize: 16)
            wrappedValue.textAlignment = .left
            wrappedValue.textColor = .black
            wrappedValue.numberOfLines = 1
            wrappedValue.lineBreakMode = .byTruncatingTail
            wrappedValue.sizeToFit()
        }
    }
    
    public init(wrappedValue: UILabel) {
        self.wrappedValue = wrappedValue
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
}

/**
 Data to be represented in the cell
 */
struct SearchResultCellModel {
    var cover: Data?
    let title: String
    let authors: [String]
    let narrators: [String]
}

class SearchResultTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "queryResultCell"
    
    /**
     Model to used to display information in the cell
     */
    var cellModel: SearchResultCellModel? {
        didSet {
            guard let cellModel = cellModel else { return }
            if let cover = cellModel.cover {
                coverImageView.image = UIImage(data: cover)
            }
            
            titleLabel.text = cellModel.title
            authorsLabel.text = "By: " + cellModel.authors.joined(separator: ", ")
            narratorsLabel.text = "With: " + cellModel.narrators.joined(separator: ", ")
        }
    }
    
    /**
    Book cover image view
    */
    let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.sizeToFit()
        return imageView
    }()
    
    /**
     Book title UILabel.
     */
    @LabelDefault
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        return label
    }()
    
    /**
     UILabel to display authors information.
     */
    @LabelDefault
    var authorsLabel = UILabel()
    
    /**
     UILabel to display narrators information.
     */
    @LabelDefault
    var narratorsLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorsLabel)
        contentView.addSubview(narratorsLabel)
        
        layoutConstraints()
    }
    
    /**
     Sets up the auto layout constraints for the cell.
     */
    func layoutConstraints() {
        let marginGuide = contentView.layoutMarginsGuide
        
        let constraints = [
            coverImageView.topAnchor.constraint(equalTo: marginGuide.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor),
            coverImageView.widthAnchor.constraint(equalToConstant: 64.0),
            
            titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            
            authorsLabel.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 10),
            authorsLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 10),
            authorsLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            
            narratorsLabel.topAnchor.constraint(equalTo: authorsLabel.bottomAnchor),
            narratorsLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 10),
            narratorsLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor),
            narratorsLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        // TODO: Implement when needed.
        fatalError("init(coder:) has not been implemented")
    }
}
