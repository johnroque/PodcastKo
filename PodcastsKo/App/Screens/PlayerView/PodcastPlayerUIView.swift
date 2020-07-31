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
import SDWebImage

class PodcastPlayerUIView: UIView {
    
    // MARK: - Dependencies
    var episode: Episode? {
        didSet {
            self.shrinkEpisodeImageView()
            self.setEpisodeData()
            self.playEpisode()
        }
    }
    
    // MARK: - Private properties
    let disposeBag = DisposeBag()
    let playerService: AudioPlayerable = MusicPlayerService()
    // player.timeControlStatus to determine the status by using player state
    var playing: Bool = false {
        didSet {
            if playing {
                playerService.play()
                playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                enlargeEpisodeImageView()
            } else {
                playerService.pause()
                playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                shrinkEpisodeImageView()
            }
        }
    }
    
    // MARK: - Views
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
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
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var sliderView: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1
        return slider
    }()
    
    private lazy var timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var durationTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var podcastTileLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .purple
        label.text = "123"
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private lazy var playerOptionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var spacerView1: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var spacerView2: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var spacerView3: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var spacerView4: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var rewindButton: UIButton = {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        button.setImage(#imageLiteral(resourceName: "rewind15"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        button.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var fastForwardButton: UIButton = {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        button.setImage(#imageLiteral(resourceName: "fastforward15"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var volumeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var muteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "muted_volume")
        return imageView
    }()
    
    private lazy var volumeSlider: UISlider = {
        let slider = UISlider()
        return slider
    }()
    
    private lazy var volubleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "max_volume")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupButtons()
        observerCurrentPlayingTime()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        self.backgroundColor = .systemBackground
        
        self.addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            containerStackView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor)
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
        
        containerStackView.addArrangedSubview(timeStackView)
        
        NSLayoutConstraint.activate([
            timeStackView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        timeStackView.addArrangedSubview(currentTimeLabel)
        timeStackView.addArrangedSubview(durationTimeLabel)
        
        containerStackView.addArrangedSubview(podcastTileLabel)
        containerStackView.addArrangedSubview(authorLabel)
        
        containerStackView.addArrangedSubview(playerOptionsStackView)

        playerOptionsStackView.addArrangedSubview(spacerView1)
        playerOptionsStackView.addArrangedSubview(rewindButton)
        playerOptionsStackView.addArrangedSubview(spacerView2)
        playerOptionsStackView.addArrangedSubview(playButton)
        playerOptionsStackView.addArrangedSubview(spacerView3)
        playerOptionsStackView.addArrangedSubview(fastForwardButton)
        playerOptionsStackView.addArrangedSubview(spacerView4)
        
        containerStackView.addArrangedSubview(volumeStackView)
        
        volumeStackView.addArrangedSubview(muteImageView)
        volumeStackView.addArrangedSubview(volumeSlider)
        volumeStackView.addArrangedSubview(volubleImageView)
        
        NSLayoutConstraint.activate([
            volumeStackView.heightAnchor.constraint(equalToConstant: 40),
            muteImageView.widthAnchor.constraint(equalToConstant: 40),
            volubleImageView.widthAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    private func setupButtons() {
        
        dissmissButton.rx
            .tap
            .asDriver()
            .drive(onNext: { [unowned self] in
                self.closeView()
            })
            .disposed(by: disposeBag)
        
        playButton.rx
            .tap
            .asDriver()
            .drive(onNext: { [unowned self] in
                self.playing.toggle()
            })
            .disposed(by: self.disposeBag)
        
        sliderView.rx
            .value
            .asDriver()
            .drive(onNext: { [unowned self] (value) in
                self.playerService.seek(to: value)
            })
            .disposed(by: self.disposeBag)
        
//        sliderView.addTarget(self, action: #selector(playerSliderValueChanged), for: .valueChanged)
        
        rewindButton.rx
            .tap
            .asDriver()
            .drive(onNext: { [unowned self] in
                self.playerService.moveTo(seconds: -15)
            })
            .disposed(by: self.disposeBag)
        
        fastForwardButton.rx
            .tap
            .asDriver()
            .drive(onNext: { [unowned self] in
                self.playerService.moveTo(seconds: 15)
            })
            .disposed(by: self.disposeBag)
        
    }
    
//    @objc private func playerSliderValueChanged(sender: UISlider!) {
//        self.playerService.seek(to: sender.value)
//    }
    
    private func setEpisodeData() {
        guard let episode = self.episode else { return }
        
        if let urlStr = episode.image, let url = URL(string: urlStr) {
            podcastImage.sd_setImage(with: url)
        } else {
            podcastImage.image = nil
        }
        
        podcastTileLabel.text = episode.title
        authorLabel.text = episode.author
        
    }
    
    private func playEpisode() {
        
        guard let streamUrlStr = self.episode?.streamUrl, let url = URL(string: streamUrlStr) else { return }
        
        playerService.setCurrent(url: url)
        playing.toggle()
    }
    
    private func observerCurrentPlayingTime() {
        
        playerService.observeCurrentTime { [unowned self] (vm) in
            self.currentTimeLabel.text = vm.getCurrentFormatted()
            self.durationTimeLabel.text = vm.getDurationFormatted()
            
            self.sliderView.value = vm.percentage
        }
        
    }
    
    private func closeView() {
        self.removeFromSuperview()
    }
    
    private func enlargeEpisodeImageView() {
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            
            self?.podcastImage.transform = .identity

        }, completion: nil)
        
    }
    
    private func shrinkEpisodeImageView() {
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            let scale: CGFloat = 0.7
            self?.podcastImage.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
        
    }
    
}
