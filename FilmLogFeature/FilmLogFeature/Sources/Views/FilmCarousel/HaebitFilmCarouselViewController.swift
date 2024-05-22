//
//  HaebitFilmCarouselViewController.swift
//  HaebitDev
//
//  Created by Seunghun on 2/18/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import UIKit

@MainActor
protocol HaebitFilmCarouselViewControllerDelegate: AnyObject {
    func carouselDidScroll(_ haebitFilmCarouselViewController: HaebitFilmCarouselViewController, toIndex index: Int)
}

final class HaebitFilmCarouselViewController: UIViewController {
    
    // MARK: - Subviews
    
    private lazy var photoCarouselContainerViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        return pageViewController
    }()
    
    private lazy var mainTitleLabel: LoadingLabel = {
        let label = LoadingLabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var titleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [mainTitleLabel, subTitleLabel])
        stack.axis = .vertical
        stack.spacing = .zero
        return stack
    }()
        
    private lazy var infoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapInfoButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.snp.makeConstraints { $0.size.equalTo(50) }
        button.layer.cornerRadius = 25
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .red
        button.backgroundColor = .white
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [deleteButton])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alpha = .zero
        return stackView
    }()
    
    // MARK: - Properties
    
    private weak var delegate: HaebitFilmCarouselViewControllerDelegate?
    private var viewModel: (any HaebitFilmCarouselViewModelProtocol)
    private var cancellables: Set<AnyCancellable> = []
    private var currentlyDisplayingViewController: UIViewController? { photoCarouselContainerViewController.viewControllers?[.zero] }
    
    @Published private var isButtonStackHidden = true
    
    // MARK: - Initializers
    
    init(viewModel: any HaebitFilmCarouselViewModelProtocol, delegate: HaebitFilmCarouselViewControllerDelegate? = nil) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        setupViews()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Callbacks
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setTitlePosition(.center)
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.titleView = titleStack
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isButtonStackHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isButtonStackHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationItem.titleView = nil
    }
    
    // MARK: - Helpers
    
    private func bind() {
        $isButtonStackHidden
            .sink { [weak self] isHidden in
                self?.updateButtonStack(isHidden: isHidden)
            }
            .store(in: &cancellables)
        
        viewModel.subTitlePublisher
            .sink { [weak self] title in
                guard let self else { return }
                UIView.transition(with: subTitleLabel, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
                    self?.subTitleLabel.text = title
                }
            }
            .store(in: &cancellables)
        
        viewModel.mainTitlePublisher
            .sink { [weak self] title in
                guard let self else { return }
                UIView.transition(with: mainTitleLabel, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
                    self?.mainTitleLabel.text = title
                }
            }
            .store(in: &cancellables)
        
        viewModel.isTitleUpdatingPublisher
            .assign(to: \.isLoading, on: mainTitleLabel)
            .store(in: &cancellables)
    }
    
    private func setupViews() {
        titleStack.snp.makeConstraints { $0.width.equalTo(250) }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
        
        view.backgroundColor = .black
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView)))
        
        addChild(photoCarouselContainerViewController)
        view.addSubview(photoCarouselContainerViewController.view)
        photoCarouselContainerViewController.didMove(toParent: self)
        photoCarouselContainerViewController.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        let index = viewModel.currentIndex
        let film = viewModel.films[index]
        let viewController = HaebitFilmViewController(film: film, index: index)
        photoCarouselContainerViewController.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        
        view.addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(40)
        }
    }
    
    private func updateButtonStack(isHidden: Bool) {
        UIView.transition(with: view, duration: 0.3) {
            self.buttonStack.alpha = isHidden ? .zero : 1.0
        }
    }
    
    @objc private func didTapView(_ sender: UITapGestureRecognizer) {
        isButtonStackHidden.toggle()
    }
    
    @objc private func didTapInfoButton(_ sender: UIButton) {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        present(vc, animated: true)
    }
}

// MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource

extension HaebitFilmCarouselViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let nextIndex = viewModel.currentIndex < viewModel.films.count - 1
            ? viewModel.currentIndex + 1
            : .zero
        guard viewModel.currentIndex != nextIndex else { return nil }
        let film = viewModel.films[nextIndex]
        let viewController = HaebitFilmViewController(film: film, index: nextIndex)
        return viewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let nextIndex = viewModel.currentIndex > .zero
            ? viewModel.currentIndex - 1
            : viewModel.films.count - 1
        guard viewModel.currentIndex != nextIndex else { return nil }
        let film = viewModel.films[nextIndex]
        let viewController = HaebitFilmViewController(film: film, index: nextIndex)
        return viewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let viewController = pendingViewControllers.first as? HaebitFilmViewController else { return }
        viewModel.currentIndex = viewController.index
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if completed {
            delegate?.carouselDidScroll(self, toIndex: viewModel.currentIndex)
        } else if let viewController = previousViewControllers.first as? HaebitFilmViewController {
            viewModel.currentIndex = viewController.index
            delegate?.carouselDidScroll(self, toIndex: viewController.index)
        }
    }
}

// MARK: - UnsplashAnimatorDelegate

extension HaebitFilmCarouselViewController: HaebitNavigationAnimatorSnapshotProvidable {
    func viewForTransition() -> UIView? {
        guard let photoViewController = currentlyDisplayingViewController as? HaebitFilmViewController else { return nil }
        return photoViewController.photoView
    }
    
    func regionForTransition() -> CGRect? {
        guard let photoViewController = currentlyDisplayingViewController as? HaebitFilmViewController else { return nil }
        photoViewController.view.layoutIfNeeded()
        return photoViewController.photoView.frame
    }
    
    func blurIntensityForSnapshot() -> CGFloat {
        .zero
    }
}
