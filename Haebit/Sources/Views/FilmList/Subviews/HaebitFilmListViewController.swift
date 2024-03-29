//
//  HaebitFilmListViewController.swift
//  HaebitDev
//
//  Created by Seunghun on 2/18/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import SwiftUI

struct HaebitFilmListView: UIViewControllerRepresentable {
    @StateObject var viewModel: HaebitFilmListViewModel
    
    func makeUIViewController(context: Context) -> some UIViewController {
        HaebitFilmListNavigationController(viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

final class HaebitFilmListNavigationController: UINavigationController {
    private let animator = HaebitNavigationAnimator()
    
    init(viewModel: HaebitFilmListViewModel) {
        super.init(rootViewController: HaebitFilmListViewController(viewModel: viewModel))
        delegate = animator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class HaebitFilmListViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Film>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Film>
    
    enum Section {
        case List
    }
    
    // MARK: - Subviews
    
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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: photoListCollectionViewFlowLayout)
        collectionView.register(HaebitFilmListCell.self, forCellWithReuseIdentifier: HaebitFilmListCell.reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.contentInset = .init(top: view.frame.height / 4.0, left: .zero, bottom: view.frame.height / 4.0, right: .zero)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.transform = .init(scaleX: 1, y: -1)
        return collectionView
    }()
    
    // MARK: - Properties
    
    private let viewModel: HaebitFilmListViewModel
    private var cancellables: Set<AnyCancellable> = []
    private var dataSource: DataSource?
    private var dataSourceSnapshot = DataSourceSnapshot()
    
    private var photoListCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }()
    
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
        viewModel.onAppear()
    }

    // MARK: - Helpers
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(photoListCollectionView)
        photoListCollectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = .clear
        appearance.titlePositionAdjustment = .zero
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
    
    private func bindUI() {
        viewModel.$films
            .receive(on: DispatchQueue.main)
            .sink { [weak self] logs in
                self?.applySnapshot(films: logs)
            }
            .store(in: &cancellables)
    }
    
    private func configureDataSource() {
        dataSource = DataSource(collectionView: photoListCollectionView) { collectionView, indexPath, film in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HaebitFilmListCell.reuseIdentifier, for: indexPath) as? HaebitFilmListCell else { return nil }
            cell.transform = .init(scaleX: 1, y: -1)
            cell.setImage(UIImage(url: film.image))
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
            HaebitFilmCarouselViewController(viewModel: viewModel, delegate: self),
            animated: true
        )
    }
}

// MARK: - PhotoCarouselViewControllerDelegate

extension HaebitFilmListViewController: HaebitFilmCarouselViewControllerDelegate {
    func carouselDidScroll(_ containerViewController: HaebitFilmCarouselViewController, toIndex currentIndex: Int) {
        let indexPath = IndexPath(item: currentIndex, section: 0)
        photoListCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
        photoListCollectionView.layoutIfNeeded()
    }
}

// MARK: - UnsplashAnimatorDelegate

extension HaebitFilmListViewController: HaebitNavigationAnimatorSnapshotProvidable {
    func viewForTransition() -> UIView? {
        let visibleCells = photoListCollectionView.indexPathsForVisibleItems
        let indexPath = IndexPath(item: viewModel.currentIndex, section: 0)

        if !visibleCells.contains(indexPath) {
            photoListCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
            photoListCollectionView.layoutIfNeeded()
        }
        
        guard let cell = photoListCollectionView.cellForItem(at: indexPath) as? HaebitFilmListCell else { return nil }
        return cell.photoView
    }

    func regionForTransition() -> CGRect? {
        view.layoutIfNeeded()
        let visibleCells = photoListCollectionView.indexPathsForVisibleItems
        let indexPath = IndexPath(item: viewModel.currentIndex, section: 0)

        if !visibleCells.contains(indexPath) {
            photoListCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
            photoListCollectionView.layoutIfNeeded()
        }

        guard let cell = photoListCollectionView.cellForItem(at: indexPath) as? HaebitFilmListCell else { return nil }
        return photoListCollectionView.convert(cell.convert(cell.photoView.frame, to: photoListCollectionView), to: view)
    }
}
