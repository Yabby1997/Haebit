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
    @StateObject var viewModel: HaebitLoggerViewModel
    
    func makeUIViewController(context: Context) -> some UIViewController {
        HaebitFilmListNavigationController(viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

class HaebitFilmListNavigationController: UINavigationController {
    private let animator = HaebitNavigationAnimator()
    
    init(viewModel: HaebitLoggerViewModel) {
        super.init(rootViewController: HaebitFilmListViewController(viewModel: viewModel))
        delegate = animator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HaebitFilmListViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Film>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Film>
    
    enum Section {
        case List
    }
    
    // MARK: - Subviews
    
    private lazy var photoListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: photoListCollectionViewFlowLayout)
        collectionView.register(HaebitFilmListCell.self, forCellWithReuseIdentifier: HaebitFilmListCell.reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.backgroundColor = .black
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = .init(top: .zero, left: .zero, bottom: view.frame.height / 2.0, right: .zero)
        collectionView.transform = .init(scaleX: 1, y: -1)
        return collectionView
    }()
    
    private lazy var shadowLayer: CAGradientLayer = {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0.0, 0.15]
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.frame = CGRect(origin: .zero, size: view.frame.size)
        return gradientLayer
    }()
    
    // MARK: - Properties
    
    private let viewModel: HaebitLoggerViewModel
    private var cancellables: Set<AnyCancellable> = []
    private var dataSource: DataSource?
    private var dataSourceSnapshot = DataSourceSnapshot()
    
    private var photoListCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }()
    
    // MARK: - Initializers
    
    init(viewModel: HaebitLoggerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Callbacks
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.bindUI()
        self.configureDataSource()
        viewModel.onAppear()
    }

    // MARK: - Helpers
    
    private func setupViews() {
        view.backgroundColor = .black
        view.addSubview(photoListCollectionView)
        photoListCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.layer.addSublayer(shadowLayer)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = .clear
        appearance.titlePositionAdjustment = .zero
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationItem.rightBarButtonItem = .init(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
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
        dataSource = DataSource(collectionView: self.photoListCollectionView) { collectionView, indexPath, film in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HaebitFilmListCell.reuseIdentifier, for: indexPath) as? HaebitFilmListCell else { return nil }
            cell.transform = .init(scaleX: 1, y: -1)
            cell.setImage(UIImage(url: film.image))
            return cell
        }
    }
    
    private func applySnapshot(films: [Film], withAnimation: Bool = false) {
        self.dataSourceSnapshot = DataSourceSnapshot()
        self.dataSourceSnapshot.appendSections([Section.List])
        self.dataSourceSnapshot.appendItems(films)
        self.dataSource?.apply(self.dataSourceSnapshot, animatingDifferences: withAnimation)
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
        CGSize(
            width: view.frame.width,
            height: view.frame.width * 38.0 / 35.0
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
