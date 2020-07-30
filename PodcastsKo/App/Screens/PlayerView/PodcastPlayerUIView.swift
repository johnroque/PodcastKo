//
//  PodcastPlayerUIView.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/30/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PodcastPlayerUIView: UIView {

    // MARK: - Private properties
    let disposeBag = DisposeBag()
    
    // MARK: - Views
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var dissmissButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Dismiss", for: .normal)
        return button
    }()
    
    private lazy var podcastImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "appicon")
        return imageView
    }()
    
    private lazy var sliderView: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private lazy var podcastTileLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "test"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        self.backgroundColor = .systemBackground
        
        self.addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 44),
            containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        containerStackView.addArrangedSubview(dissmissButton)
        
        NSLayoutConstraint.activate([
            dissmissButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        containerStackView.addArrangedSubview(podcastImage)
        
        podcastImage.addConstraint(NSLayoutConstraint(item: podcastImage, attribute: .height, relatedBy: .equal, toItem: podcastImage, attribute: .width, multiplier: 1, constant: 0))
        
        containerStackView.addArrangedSubview(sliderView)
        
        NSLayoutConstraint.activate([
            sliderView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        containerStackView.addArrangedSubview(podcastTileLabel)
        
    }
    
    private func setupButtons() {
        
        dissmissButton.rx
            .tap
            .asDriver()
            .drive(onNext: { [unowned self] in
                self.removeFromSuperview()
            })
            .disposed(by: disposeBag)
        
    }
    
}
