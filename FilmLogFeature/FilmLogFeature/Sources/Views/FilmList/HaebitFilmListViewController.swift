//
//  HaebitFilmListViewController.swift
//  HaebitDev
//
//  Created by Seunghun on 2/18/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import HaebitCommonModels
import UIKit

fileprivate class PhotoListCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        scrollDirection = .vertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)
        attributes?.transform = .init(scaleX: 1, y: -1)
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        if let attributes { attributes.forEach { $0.transform = .init(scaleX: 1, y: -1) } }
        return attributes
    }
}

final class HaebitFilmListViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Film>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Film>
    
    enum Section {
        case List
    }
    
    // MARK: - Subviews
    
    private lazy var titleStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        stack.addArrangedSubview(mainTitleLabel)
        stack.addArrangedSubview(subtitleLabel)
        return stack
    }()
    
    private let mainTitleLabel: LoadingLabel = {
        let label = LoadingLabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private let subtitleLabel = SubtitleLabel()

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = .zero
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 10
        button.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        return button
    }()
    
    private lazy var photoListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: PhotoListCollectionViewFlowLayout())
        collectionView.register(HaebitFilmListCell.self, forCellWithReuseIdentifier: HaebitFilmListCell.reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.contentInset = .init(top: view.frame.height / 4.0, left: .zero, bottom: view.frame.height / 4.0, right: .zero)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.transform = .init(scaleX: 1, y: -1)
        return collectionView
    }()
    
    private lazy var shadowLayer: CAGradientLayer = {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.5).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.locations = [0.0, 0.2]
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: .zero, y: 1.0)
        gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: view.frame.height)
        return gradientLayer
    }()
    
    // MARK: - Properties
    
    private let viewModel: HaebitFilmListViewModel
    private var cancellables: Set<AnyCancellable> = []
    private var dataSource: DataSource?
    private var dataSourceSnapshot = DataSourceSnapshot()
    
    // MARK: - Initializers
    
    init(viewModel: HaebitFilmListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Callbacks
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindUI()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setTitlePosition(.left)
        navigationItem.titleView = titleStackView
        scrollToCurrentIndexIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.titleView = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.onAppear()
    }

    // MARK: - Helpers
    
    private func setupViews() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = .clear
        appearance.titlePositionAdjustment = .zero
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
        
        view.backgroundColor = .white
        view.addSubview(photoListCollectionView)
        photoListCollectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        view.layer.addSublayer(shadowLayer)
    }
    
    private func bindUI() {
        viewModel.filmsPublisher
            .sink { [weak self] logs in
                self?.applySnapshot(films: logs)
            }
            .store(in: &cancellables)
        
        viewModel.mainTitlePublisher
            .sink { [weak self] title in
                guard let self else { return }
                UIView.transition(with: mainTitleLabel, duration: 0.3, options: .transitionCrossDissolve) {
                    self.mainTitleLabel.text = title
                }
            }
            .store(in: &cancellables)
        
        viewModel.isTitleUpdatingPublisher
            .sink { [weak self] isUpdating in
                self?.mainTitleLabel.isLoading = isUpdating
            }
            .store(in: &cancellables)
        
        viewModel.subTitlePublisher
            .sink { [weak self] title in
                guard let self else { return }
                subtitleLabel.text = title
            }
            .store(in: &cancellables)
    }
    
    private func configureDataSource() {
        dataSource = DataSource(collectionView: photoListCollectionView) { [weak self] collectionView, indexPath, film in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HaebitFilmListCell.reuseIdentifier, for: indexPath)
            guard let self, let cell = cell as? HaebitFilmListCell else { return cell }
            cell.frameView.image = viewModel.perforationShape.frameImage
            cell.photoView.setImage(UIImage(url: film.image))
            return cell
        }
    }
    
    private func applySnapshot(films: [Film], withAnimation: Bool = false) {
        dataSourceSnapshot = DataSourceSnapshot()
        dataSourceSnapshot.appendSections([Section.List])
        dataSourceSnapshot.appendItems(films)
        dataSource?.apply(dataSourceSnapshot, animatingDifferences: withAnimation)
    }
    
    @objc private func didTapClose(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    private func updateCurrentIndex() {
        let center = view.convert(photoListCollectionView.center, to: photoListCollectionView)
        let indexPath = photoListCollectionView.indexPathForItem(at: center)
        viewModel.currentIndex = indexPath?.item ?? .zero
    }
    
    private func scrollToCurrentIndexIfNeeded(animated: Bool = false) {
        let indexPath = IndexPath(item: viewModel.currentIndex, section: .zero)
        guard photoListCollectionView.numberOfSections > .zero,
              (.zero..<photoListCollectionView.numberOfItems(inSection: .zero)).contains(indexPath.item),
              photoListCollectionView.indexPathsForVisibleItems.contains(indexPath) == false else { return }
        photoListCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: animated)
        photoListCollectionView.layoutIfNeeded()
    }
}

// MARK: - UIScrollViewDelegate

extension HaebitFilmListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollSpeed = scrollView.panGestureRecognizer.velocity(in: scrollView.superview).y
        if scrollView.isDragging { updateCurrentIndex() }
        if scrollSpeed < .zero {
            tabBarController?.setTabBarHidden(false, animated: true)
        } else if scrollSpeed > .zero {
            tabBarController?.setTabBarHidden(true, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HaebitFilmListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.frame.width - 12.0
        return CGSize(
            width: width,
            height: ceil(width * 38.0 / 35.0)
        )
    }
}

// MARK: - UICollectionViewDelegate

extension HaebitFilmListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.currentIndex = indexPath.item
        navigationController?.pushViewController(
            HaebitFilmCarouselViewController(viewModel: viewModel),
            animated: true
        )
    }
}

// MARK: - UnsplashAnimatorDelegate

extension HaebitFilmListViewController: HaebitNavigationAnimatorSnapshotProvidable {
    func viewForTransition() -> UIView? {
        let indexPath = IndexPath(item: viewModel.currentIndex, section: 0)
        guard let cell = photoListCollectionView.cellForItem(at: indexPath) as? HaebitFilmListCell else { return nil }
        return cell.photoView
    }
    
    func regionForTransition() -> CGRect? {
        view.layoutIfNeeded()
        let indexPath = IndexPath(item: viewModel.currentIndex, section: 0)
        guard let cell = photoListCollectionView.cellForItem(at: indexPath) as? HaebitFilmListCell else { return nil }
        return photoListCollectionView.convert(cell.convert(cell.photoView.frame, to: photoListCollectionView), to: view)
    }
    
    func blurIntensityForSnapshot() -> CGFloat {
        .zero
    }
}
