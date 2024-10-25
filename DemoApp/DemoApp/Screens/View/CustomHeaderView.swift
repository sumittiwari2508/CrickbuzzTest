//
//  CustomHeaderView.swift
//  DemoApp
//
//  Created by Sumit Tiwari on 24/10/24.
//

import UIKit

class CustomHeaderView: UITableViewHeaderFooterView {
    let arrowImageView = UIImageView()
    private let bottomLine = UIView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
        
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        // Configure the arrow image view
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(arrowImageView)
        
        // Set constraints for the arrow image with padding
        NSLayoutConstraint.activate([
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.widthAnchor.constraint(equalToConstant: 12),
            arrowImageView.heightAnchor.constraint(equalToConstant: 12)
        ])
        
        // Configure the bottom line
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.backgroundColor = .lightGray // Adjust color as needed
        contentView.addSubview(bottomLine)
        
        // Set constraints for the bottom line
        NSLayoutConstraint.activate([
            bottomLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bottomLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bottomLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        
       
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .black
        contentView.addSubview(titleLabel)
        
        // Set constraints for the title label with padding
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -8)
        ])
    }
    
    func updateArrow(isExpanded: Bool) {
        
        let imageName = isExpanded ? "down-arrow" : "right-arrow"
        arrowImageView.image = UIImage(named: imageName)
    }
}
