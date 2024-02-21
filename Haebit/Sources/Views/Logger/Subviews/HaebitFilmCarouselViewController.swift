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
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private lazy var sponsorLabel: UILabel = {
        let label = UILabel()
        label.text = "Sponsored"
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var infoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [usernameLabel, sponsorLabel])
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()
        
    // MARK: - Properties
    
    private weak var delegate: HaebitFilmCarouselViewControllerDelegate?
    private var viewModel: HaebitLoggerViewModel
    private var cancellables: Set<AnyCancellable> = []
    private var currentlyDisplayingViewController: UIViewController? { photoCarouselContainerViewController.viewControllers?[.zero] }
    private var navigationAnimator: HaebitNavigationAnimator
    
    // MARK: - Initializers
    
    init(viewModel: HaebitLoggerViewModel, delegate: HaebitFilmCarouselViewControllerDelegate, navigationAnimator: HaebitNavigationAnimator) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.navigationAnimator = navigationAnimator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Callbacks
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.alpha = 1.0
        self.tabBarController?.tabBar.isHidden = false
//        self.navigationController?.navigationBar.standardAppearance = Appearances.transparentNavigationBar
//        self.navigationController?.navigationBar.scrollEdgeAppearance = Appearances.transparentNavigationBar
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        self.view.backgroundColor = .black//unsplashTheme
        
        self.navigationItem.titleView = self.infoStack
        
        self.addChild(self.photoCarouselContainerViewController)
        self.view.addSubview(self.photoCarouselContainerViewController.view)
        self.photoCarouselContainerViewController.didMove(toParent: self)
        
        let index = self.viewModel.currentIndex
        let film = self.viewModel.films[index]
        let viewController = HaebitFilmViewController(film: film, index: index)
        self.photoCarouselContainerViewController.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
    }
    
    private func bindUI() {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanView))
        view.addGestureRecognizer(gestureRecognizer)
//        self.view.publisher(for: UIPanGestureRecognizer())
//            .sink { [weak self] gesture in
//                self?.handlePanGesture(gesture)
//            }
//            .store(in: &self.cancellables)
        
//        self.viewModel.$currentIndex
//            .sink { [weak self] index in
//                guard (self?.viewModel.films[index]) != nil else { return }
////                self?.usernameLabel.text = photo.user
////                self?.sponsorLabel.isHidden = photo.sponsor == nil
//            }
//            .store(in: &self.cancellables)
    }
    
    @objc private func didPanView(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard gesture.velocity(in: view).y > .zero else { return }
            navigationAnimator.isDismissingWithGesture = true
        case .changed:
            guard navigationAnimator.isDismissingWithGesture else {
                print("UP")
                return
            }
        case .ended:
            guard navigationAnimator.isDismissingWithGesture else { return }
            navigationAnimator.isDismissingWithGesture = false
        default:
            break
        }
        navigationAnimator.dismissWithGesture(
            translation: gesture.translation(in: view),
            velocity: gesture.velocity(in: view),
            isEnded: gesture.state == .ended
        )
        navigationController?.popViewController(animated: true)
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
        self.viewModel.nextIndex = nextViewController.currentIndex
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed, let nextIndex = self.viewModel.nextIndex else { return self.viewModel.nextIndex = nil }
        
//        previousViewControllers.forEach {
//            guard let previousViewController = $0 as? HaebitFilmViewController else { return }
////            previousViewController.scrollView.zoomScale = previousViewController.scrollView.minimumZoomScale
//        }
        
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
