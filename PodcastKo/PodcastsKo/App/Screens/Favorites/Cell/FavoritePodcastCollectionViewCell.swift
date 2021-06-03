//
//  FavoritePodcastCollectionViewCell.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 8/5/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import UIKit
import SDWebImage
import PodcastKoCore

class FavoritePodcastCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Views
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var imageIconView: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "appicon")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.text = "123"
        return label
    }()
    
    private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "123"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        contentStackView.addArrangedSubview(imageIconView)
        
        NSLayoutConstraint.activate([
            imageIconView.heightAnchor.constraint(equalTo: imageIconView.widthAnchor)
        ])
        
        contentStackView.addArrangedSubview(nameLabel)
        contentStackView.addArrangedSubview(artistNameLabel)
        
    }
    
    func configure(podcast: Podcast) {
        
        self.artistNameLabel.text = podcast.artistName ?? ""
        self.nameLabel.text = podcast.trackName ?? ""
     
        if let urlString = podcast.artworkUrl600, let url = URL(string: urlString) {
            imageIconView.sd_setImage(with: url)
        }
        
    }
    
}
