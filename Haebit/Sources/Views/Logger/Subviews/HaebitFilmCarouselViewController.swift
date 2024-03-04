//
//  HaebitFilmCarouselViewController.swift
//  HaebitDev
//
//  Created by Seunghun on 2/18/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import UIKit

protocol HaebitFilmCarouselViewControllerDelegate: AnyObject {
    func carouselDidScroll(_ haebitFilmCarouselViewController: HaebitFilmCarouselViewController, toIndex index: Int)
}

class HaebitFilmCarouselViewController: UIViewController {
    
    // MARK: - Subviews
    
    private lazy var photoCarouselContainerViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.view.frame = self.view.frame
        pageViewController.delegate = self
        pageViewController.dataSource = self
        return pageViewController
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var infoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [locationLabel, dateLabel])
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()
        
    // MARK: - Properties
    
    private weak var delegate: HaebitFilmCarouselViewControllerDelegate?
    private var viewModel: HaebitLoggerViewModel
    private var cancellables: Set<AnyCancellable> = []
    private var currentlyDisplayingViewController: UIViewController? { photoCarouselContainerViewController.viewControllers?[.zero] }
    
    // MARK: - Initializers
    
    init(viewModel: HaebitLoggerViewModel, delegate: HaebitFilmCarouselViewControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Callbacks
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.titleView = infoStack
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationItem.titleView = nil
    }
    
    // MARK: - Helpers
    
    private func bind() {
        viewModel.$currentFilmAddress
            .sink { [weak self] location in
                self?.locationLabel.text = location
            }
            .store(in: &cancellables)
        
        viewModel.$currentFilmTime
            .sink { [weak self] time in
                self?.dateLabel.text = time
            }
            .store(in: &cancellables)
    }
    
    private func setupViews() {
        view.backgroundColor = .black
        
        addChild(photoCarouselContainerViewController)
        view.addSubview(photoCarouselContainerViewController.view)
        photoCarouselContainerViewController.didMove(toParent: self)
        
        let index = viewModel.currentIndex
        let film = viewModel.films[index]
        let viewController = HaebitFilmViewController(film: film, index: index)
        photoCarouselContainerViewController.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
    }
}

// MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource

extension HaebitFilmCarouselViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard viewModel.currentIndex > 0 else { return nil }
        let index = viewModel.currentIndex - 1
        let film = viewModel.films[index]
        let viewController = HaebitFilmViewController(film: film, index: index)
        return viewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard viewModel.currentIndex < viewModel.films.count - 1 else { return nil }
        let index = self.viewModel.currentIndex + 1
        let film = self.viewModel.films[index]
        let viewController = HaebitFilmViewController(film: film, index: index)
        return viewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let nextViewController = pendingViewControllers.first as? HaebitFilmViewController else { return }
        viewModel.nextIndex = nextViewController.index
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed, let nextIndex = self.viewModel.nextIndex else { return self.viewModel.nextIndex = nil }
        self.viewModel.currentIndex = nextIndex
        self.delegate?.carouselDidScroll(self, toIndex: nextIndex)
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
}
