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

extension PodcastPlayerUIView {
    
    func configureMaximize() {
        self.containerStackView.alpha = 1
        self.minimizeView.alpha = 0
    }
    
    func configureMinimize() {
        self.containerStackView.alpha = 0
        self.minimizeView.alpha = 1
    }
    
    @objc private func handleMinimixeToMaximize() {
        let window = UIWindow.key
        if let nav = window?.rootViewController as? UINavigationController,
            let mainTab = nav.viewControllers.first as? MainTabBarController {
            
            mainTab.showPlayer(episode: nil)
            
        }
    }
    
    @objc private func handleViewPaning(gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .changed {
            handlePanChange(gesture: gesture)
        } else if gesture.state == .ended {
            handlePanEnded(gesture: gesture)
        }
        
    }
    
    private func handlePanChange(gesture: UIPanGestureRecognizer) {

        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        self.minimizeView.alpha = 1 + translation.y / 200
        self.containerStackView.alpha = -translation.y / 200
        
    }
    
    private func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            
            self?.transform = .identity
            
            if translation.y < -200 || velocity.y < -500 {
                let window = UIWindow.key
                if let nav = window?.rootViewController as? UINavigationController,
                    let mainTab = nav.viewControllers.first as? MainTabBarController {
                    
                    mainTab.showPlayer(episode: nil)
                    
                }
            } else {
                self?.configureMinimize()
            }
            
        }, completion: nil)
    }
    
    @objc private func handleMinimizePanGesture(gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .changed {
            handleMinimizePanChange(gesture: gesture)
        } else if gesture.state == .ended {
            handleMinimizePanEnded(gesture: gesture)
        }
        
    }
    
    private func handleMinimizePanChange(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.superview)
        containerStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
    }
    
    private func handleMinimizePanEnded(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.superview)
//        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            
            self?.containerStackView.transform = .identity

            if translation.y > 100 {
                let window = UIWindow.key
                if let nav = window?.rootViewController as? UINavigationController,
                    let mainTab = nav.viewControllers.first as? MainTabBarController {

                    mainTab.minimizePlayer()

                }
            }
            
        }, completion: nil)
        
    }
    
}

extension PodcastPlayerUIView: AudioCommandCenterServiceable {
    
    func pause() {
        self.playing = false
    }
    
    func play() {
        self.playing = true
    }
    
    func playNextTrack() {
        guard let episode = self.episode else { return }
        
        let epIndex = self.episodes.firstIndex { (ep) -> Bool in
            return episode.title == ep.title && episode.author == ep.author
        }
        
        if let epIndexInt = epIndex {
            
            let index = (epIndexInt + 1) >= (self.episodes.count) ? 0 : epIndexInt + 1
            
            let nextEp = self.episodes[index]
            
            self.episode = nextEp
            
        }
    }
    
    func playPreviousTrack() {
        
        guard let episode = self.episode else { return }
        
        let epIndex = self.episodes.firstIndex { (ep) -> Bool in
            return episode.title == ep.title && episode.author == ep.author
        }
        
        if let epIndexInt = epIndex {
            
            let index = (epIndexInt) <= 0 ? (self.episodes.count - 1) : epIndexInt - 1
            
            let nextEp = self.episodes[index]
            
            self.episode = nextEp
            
        }
        
    }
    
}

class PodcastPlayerUIView: UIView {
    
    // MARK: - Dependencies
    var episode: Episode? {
        didSet {
            self.shrinkEpisodeImageView()
            self.setEpisodeData()
            self.playEpisode()
            
//            if let episode = episode {
//                self.playerService.setupBackgroundInfo(title: episode.title ?? "",
//                                                       author: episode.author ?? "",
//                                                       image: nil)
//            }
            
        }
    }
    var episodes: [Episode] = []
    
    // MARK: - Private properties
    let disposeBag = DisposeBag()
    let playerService: AudioPlayerable = MusicPlayerService()
    // player.timeControlStatus to determine the status by using player state
    var playing: Bool = false {
        didSet {
            if playing {
                playerService.play()
                playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                minimizePausePlayButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                enlargeEpisodeImageView()
            } else {
                playerService.pause()
                playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                minimizePausePlayButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                shrinkEpisodeImageView()
            }
        }
    }
    
    // MARK: - Views
    
    private lazy var minimizeView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMinimixeToMaximize)))
//        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(h)))
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleViewPaning)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var minimizeSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var minimizeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var minimizeIconImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var minimizeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var minimizePausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(nil, for: .normal)
        button.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        button.tintColor = UIColor(named: "textColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var minimizeFastForwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(nil, for: .normal)
        button.setImage(#imageLiteral(resourceName: "fastforward15"), for: .normal)
        button.tintColor = UIColor(named: "textColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var minimizeCloseView: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleMinimizePanGesture)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var minimizeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(nil, for: .normal)
        button.setImage(#imageLiteral(resourceName: "arrow-down"), for: .normal)
        button.tintColor = UIColor(named: "textColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        button.tintColor = UIColor(named: "textColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
//    private lazy var dissmissButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("Dismiss", for: .normal)
//        button.setTitleColor(UIColor(named: "textColor"), for: .normal)
//        return button
//    }()
    
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
        let button = UIButton(type: .system)
        button.setTitle(nil, for: .normal)
        button.setImage(#imageLiteral(resourceName: "rewind15"), for: .normal)
        button.tintColor = UIColor(named: "textColor")!
        return button
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(nil, for: .normal)
        button.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        button.tintColor = UIColor(named: "textColor")!
        return button
    }()
    
    private lazy var fastForwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(nil, for: .normal)
        button.setImage(#imageLiteral(resourceName: "fastforward15"), for: .normal)
        button.tintColor = UIColor(named: "textColor")!
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
        imageView.tintColor = UIColor(named: "textColor")!
        return imageView
    }()
    
    private lazy var volumeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 1
        return slider
    }()
    
    private lazy var volubleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "max_volume")
        imageView.tintColor = UIColor(named: "textColor")!
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupButtons()
        observerCurrentPlayingTime()
        
        playerService.setupRemoteControl(commandCenterService: self)
        playerService.setupAudioSession()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        self.backgroundColor = .systemBackground
        
        self.addSubview(minimizeView)
        
        NSLayoutConstraint.activate([
            minimizeView.topAnchor.constraint(equalTo: self.topAnchor),
            minimizeView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            minimizeView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            minimizeView.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        minimizeView.addSubview(minimizeSeperatorView)
        
        NSLayoutConstraint.activate([
            minimizeSeperatorView.topAnchor.constraint(equalTo: minimizeView.topAnchor),
            minimizeSeperatorView.leadingAnchor.constraint(equalTo: minimizeView.leadingAnchor),
            minimizeSeperatorView.trailingAnchor.constraint(equalTo: minimizeView.trailingAnchor),
            minimizeSeperatorView.heightAnchor.constraint(equalToConstant: 0.5),
        ])
        
        minimizeView.addSubview(minimizeStackView)
        
        NSLayoutConstraint.activate([
            minimizeStackView.topAnchor.constraint(equalTo: minimizeView.topAnchor, constant: 8),
            minimizeStackView.leadingAnchor.constraint(equalTo: minimizeView.leadingAnchor, constant: 8),
            minimizeStackView.trailingAnchor.constraint(equalTo: minimizeView.trailingAnchor, constant: -8),
            minimizeStackView.bottomAnchor.constraint(equalTo: minimizeView.bottomAnchor, constant: -8),
        ])
        
        minimizeStackView.addArrangedSubview(minimizeIconImage)
        minimizeStackView.addArrangedSubview(minimizeTitleLabel)
        minimizeStackView.addArrangedSubview(minimizePausePlayButton)
        minimizeStackView.addArrangedSubview(minimizeFastForwardButton)
        
        NSLayoutConstraint.activate([
            minimizeIconImage.widthAnchor.constraint(equalToConstant: 48),
            minimizePausePlayButton.widthAnchor.constraint(equalToConstant: 48),
            minimizeFastForwardButton.widthAnchor.constraint(equalToConstant: 48)
        ])
        
        self.addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            containerStackView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor)
        ])
        
        containerStackView.addArrangedSubview(minimizeCloseView)
        minimizeCloseView.addSubview(minimizeButton)
        
        NSLayoutConstraint.activate([
            minimizeButton.topAnchor.constraint(equalTo: minimizeCloseView.topAnchor, constant: 8),
            minimizeButton.leadingAnchor.constraint(equalTo: minimizeCloseView.leadingAnchor, constant: 16),
            minimizeButton.bottomAnchor.constraint(equalTo: minimizeCloseView.bottomAnchor, constant: -8),
            minimizeButton.heightAnchor.constraint(equalToConstant: 25),
            minimizeButton.widthAnchor.constraint(equalToConstant: 25)
        ])
        
//        minimizeCloseView.addSubview(closeButton)
//
//        NSLayoutConstraint.activate([
//            closeButton.topAnchor.constraint(equalTo: minimizeCloseView.topAnchor, constant: 8),
//            closeButton.trailingAnchor.constraint(equalTo: minimizeCloseView.trailingAnchor, constant: -16),
//            closeButton.bottomAnchor.constraint(equalTo: minimizeCloseView.bottomAnchor, constant: -8),
//            closeButton.heightAnchor.constraint(equalToConstant: 25),
//            closeButton.widthAnchor.constraint(equalToConstant: 25)
//        ])
        
//        containerStackView.addArrangedSubview(dissmissButton)
        
//        NSLayoutConstraint.activate([
//            dissmissButton.heightAnchor.constraint(equalToConstant: 44)
//        ])
        
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
        
        minimizeButton.rx
            .tap
            .asDriver()
            .drive(onNext: { [unowned self] in
                self.closeView()
            })
            .disposed(by: self.disposeBag)
        
        playButton.rx
            .tap
            .asDriver()
            .drive(onNext: { [unowned self] in
                self.playing.toggle()
            })
            .disposed(by: self.disposeBag)
        
        minimizePausePlayButton.rx
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
        
        minimizeFastForwardButton.rx
            .tap
            .asDriver()
            .drive(onNext: { [unowned self] in
                self.playerService.moveTo(seconds: 15)
            })
            .disposed(by: self.disposeBag)
        
        volumeSlider.rx
            .value
            .asDriver()
            .drive(onNext: { [unowned self] (value) in
                self.playerService.volume(value: value)
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
            minimizeIconImage.sd_setImage(with: url) { [weak self] (image, _, _, _) in
                
                self?.playerService.setupBackgroundInfo(title: episode.title ?? "",
                                                       author: episode.author ?? "",
                                                       image: image)
                
                
            }
        } else {
            podcastImage.image = nil
            minimizeIconImage.image = nil
        }
        
        podcastTileLabel.text = episode.title
        authorLabel.text = episode.author
        
        minimizeTitleLabel.text = episode.title
        
    }
    
    private func playEpisode() {
        
        guard let streamUrlStr = self.episode?.streamUrl, let url = URL(string: streamUrlStr) else { return }
        
        playerService.setCurrent(url: url)
        playing = true
    }
    
    private func observerCurrentPlayingTime() {
        
        playerService.observeCurrentTime { [unowned self] (vm) in
            self.currentTimeLabel.text = vm.getCurrentFormatted()
            self.durationTimeLabel.text = vm.getDurationFormatted()
            
            self.sliderView.value = vm.percentage
        }
        
    }
    
    private func closeView() {
        let window = UIWindow.key
        if let nav = window?.rootViewController as? UINavigationController,
            let mainTab = nav.viewControllers.first as? MainTabBarController {
            
            mainTab.minimizePlayer()
            
        }
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
