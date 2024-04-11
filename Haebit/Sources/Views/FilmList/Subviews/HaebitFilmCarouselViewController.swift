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

final class HaebitFilmCarouselViewController: UIViewController {
    
    // MARK: - Subviews
    
    private lazy var photoCarouselContainerViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        return pageViewController
    }()
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var titleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [mainTitleLabel, subTitleLabel])
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()
        
    // MARK: - Properties
    
    private weak var delegate: HaebitFilmCarouselViewControllerDelegate?
    private var viewModel: HaebitFilmLogViewModel
    private var cancellables: Set<AnyCancellable> = []
    private var currentlyDisplayingViewController: UIViewController? { photoCarouselContainerViewController.viewControllers?[.zero] }
    
    // MARK: - Initializers
    
    init(viewModel: HaebitFilmLogViewModel, delegate: HaebitFilmCarouselViewControllerDelegate) {
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
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.titleView = titleStack
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationItem.titleView = nil
    }
    
    // MARK: - Helpers
    
    private func bind() {
        viewModel.$mainTitle.zip(viewModel.$subTitle)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] mainTitle, subTitle in
                self?.updateTitle(main: mainTitle, sub: subTitle)
            }
            .store(in: &cancellables)
    }
    
    private func setupViews() {
        view.backgroundColor = .black
        
        addChild(photoCarouselContainerViewController)
        view.addSubview(photoCarouselContainerViewController.view)
        photoCarouselContainerViewController.didMove(toParent: self)
        photoCarouselContainerViewController.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        let index = viewModel.currentIndex
        let film = viewModel.films[index]
        let viewController = HaebitFilmViewController(film: film, index: index)
        photoCarouselContainerViewController.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
    }
    
    private func updateTitle(main: String, sub: String) {
        UIView.transition(with: titleStack, duration: 0.2, options: .transitionCrossDissolve) { [weak self] in
            self?.mainTitleLabel.text = main
            self?.subTitleLabel.text = sub
        }
    }
}

// MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource

extension HaebitFilmCarouselViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard viewModel.currentIndex < viewModel.films.count - 1 else { return nil }
        let index = viewModel.currentIndex + 1
        let film = viewModel.films[index]
        let viewController = HaebitFilmViewController(film: film, index: index)
        return viewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard viewModel.currentIndex > 0 else { return nil }
        let index = viewModel.currentIndex - 1
        let film = viewModel.films[index]
        let viewController = HaebitFilmViewController(film: film, index: index)
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
}
