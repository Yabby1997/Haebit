import SwiftUI
import UIKit
import HaebitLogger

public struct HaebitFilmLogView: View {
    private let logger: HaebitLogger
    private let preferenceProvider: LoggerPreferenceProvidable
    
    public init(
        logger: HaebitLogger,
        preferenceProvider: LoggerPreferenceProvidable
    ) {
        self.logger = logger
        self.preferenceProvider = preferenceProvider
    }
    
    public var body: some View {
        HaebitFilmLogViewRepresentable(
            logger: logger,
            preferenceProvider: preferenceProvider
        )
        .persistentSystemOverlays(.hidden)
        .statusBarHidden()
        .ignoresSafeArea()
    }
}

struct HaebitFilmLogViewRepresentable: UIViewControllerRepresentable {
    let logger: HaebitLogger
    let preferenceProvider: LoggerPreferenceProvidable
    
    init(
        logger: HaebitLogger,
        preferenceProvider: LoggerPreferenceProvidable
    ) {
        self.logger = logger
        self.preferenceProvider = preferenceProvider
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let listViewController = HaebitFilmListViewController(
            viewModel:  HaebitFilmListViewModel(
                logger: logger,
                preferenceProvider: preferenceProvider
            )
        )
        let listNavigationController = HaebitFilmLogNavigationController(rootViewController: listViewController)
        listNavigationController.tabBarItem = UITabBarItem(title: nil, image: .init(systemName: "photo.stack"), tag: 0)
        
        let mapViewController = HaebitFilmMapViewController(
            viewModel: HaebitFilmMapViewModel(
                logger: logger,
                preferenceProvider: preferenceProvider
            )
        )
        let mapNavigationController = HaebitFilmLogNavigationController(rootViewController: mapViewController)
        mapNavigationController.tabBarItem = UITabBarItem(title: nil, image: .init(systemName: "map.fill"), tag: 0)
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = UIColor(red: 83 / 255, green: 83 / 255, blue: 83 / 255, alpha: 1.0)
        itemAppearance.selected.iconColor = .white
        
        let barAppearance = UITabBarAppearance()
        barAppearance.configureWithOpaqueBackground()
        barAppearance.backgroundColor = .black
        barAppearance.inlineLayoutAppearance = itemAppearance
        barAppearance.stackedLayoutAppearance = itemAppearance
        barAppearance.compactInlineLayoutAppearance = itemAppearance
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.standardAppearance = barAppearance
        tabBarController.tabBar.scrollEdgeAppearance = barAppearance
        tabBarController.viewControllers = [
            listNavigationController,
            mapNavigationController
        ]
        
        return tabBarController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
